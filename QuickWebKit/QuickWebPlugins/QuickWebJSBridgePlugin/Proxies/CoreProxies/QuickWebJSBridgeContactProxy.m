//
//  QuickWebJSBridgeContactProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgeContactProxy.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <ContactsUI/ContactsUI.h>
#import "QuickWebStringUtil.h"
#import "QuickWebDataParseUtil.h"
#import "QuickWebKit.h"
#import "UIView+QuickWeb.h"

@interface QuickWebJSBridgeContactProxy()<ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>
{
    NSString * _name;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;

@property (nonatomic, strong) QuickWebJSBridgeInvokeCommand* contactCommand;
@property (nonatomic, strong) QuickWebJSCallBack contactCallback;

@property (nonatomic, strong) QuickWebJSBridgeInvokeCommand* queryContactCommand;
@property (nonatomic, strong) QuickWebJSCallBack queryContactCallback;
@end

@implementation QuickWebJSBridgeContactProxy
-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"contact" : _name;
}

-(void)setName:(NSString *)name
{
    _name = name;
}

-(id)initWithResultHandler:(id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol>)handler
{
    if(self = [super init])
    {
        _resultHandler = handler;
    }
    return self;
}


-(NSString*)callAction:(NSString*)actionId command:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if([actionId isEqualToString:@"100"])
    {
        return [self chooseContact:command callback:callback];
    }
    else if([actionId isEqualToString:@"101"])
    {
        return [self queryContact:command callback:callback];
    }
    
    return NSStringFromBOOL(FALSE);
}


-(NSString*) chooseContact:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    if(!self.contactCommand)self.contactCommand = command;
    if(!self.contactCallback)self.contactCallback = callback;
    if (@available(iOS 9.0, *))
    {
        CNContactPickerViewController *pickController = [[CNContactPickerViewController alloc] init];
        pickController.delegate = self;
        
        UIViewController *viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        if([self.resultHandler conformsToProtocol:@protocol(SmartJSBridgeProtocol)])
        {
            UIView * webView = [self.resultHandler getSmartJSWebViewBySecretId:command.secretId];
            if([webView isKindOfClass:[UIView class]])
            {
                viewController = [webView quickweb_FindViewController];
            }
        }
        [viewController presentViewController:pickController animated:YES completion:nil];
    }
    else
    {
        ABPeoplePickerNavigationController *pickController = [[ABPeoplePickerNavigationController alloc] init];
        if (@available(iOS 8.0, *))
        {
            pickController.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        }
        pickController.peoplePickerDelegate = self;
        
        UIViewController *viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        if([self.resultHandler conformsToProtocol:@protocol(SmartJSBridgeProtocol)])
        {
            UIView * webView = [self.resultHandler getSmartJSWebViewBySecretId:command.secretId];
            if([webView isKindOfClass:[UIView class]])
            {
                viewController = [webView quickweb_FindViewController];
            }
        }
        [viewController presentViewController:pickController animated:YES completion:nil];
    }
    return NSStringFromBOOL(TRUE);
}


-(NSString*) queryContact:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSString *text = [args objectForKey:@"content"];
    if([QuickWebStringUtil isStringBlank:text])
    {
        return NSStringFromBOOL(FALSE);
    }
    if(!self.queryContactCommand)self.queryContactCommand = command;
    if(!self.queryContactCallback)self.queryContactCallback = callback;
    
    [self queryContactByNumber:text];
    return NSStringFromBOOL(TRUE);
}

#pragma mark choose contact private

//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    if (self.contactCommand && self.contactCallback)
    {
        QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:NO secretId:self.contactCommand.secretId callbackId:self.contactCommand.callbackId resultWithDict:[NSDictionary dictionary]];
        self.contactCallback(result);
        self.contactCommand = nil;
        self.contactCallback = nil;
    }
}


//iOS 8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    CFStringRef cFirstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    CFStringRef cLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *firstName = @"";
    
    if (cFirstName)
    {
        firstName = (__bridge_transfer NSString *) (cFirstName);
    }
    NSString *lastName = @"";
    if (cLastName)
    {
        lastName = (__bridge_transfer NSString *) (cLastName);
    }
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone, identifier);
    NSString *phoneNO = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phone, index);
    
    
    if ([phoneNO hasPrefix:@"+"])
    {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (phone && [phoneNO isKindOfClass:[NSString class]] && [phoneNO length] > 0)
    {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        
        if (self.contactCommand && self.contactCallback)
        {
            
            NSString *text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@ %@\\\",\\\"num\\\":\\\"%@\\\"}", firstName, lastName, phoneNO];
            if([QuickWebStringUtil isStringHasChineseCharacter:firstName])
            {
                text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@%@\\\",\\\"num\\\":\\\"%@\\\"}", lastName, firstName, phoneNO];
            }
            
            QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:self.contactCommand.secretId callbackId:self.contactCommand.callbackId resultWithString:text];
            self.contactCallback(result);
            self.contactCommand = nil;
            self.contactCallback = nil;
        }
    }
}

//iOS 7
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    CFStringRef cFirstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    CFStringRef cLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *firstName = (__bridge_transfer NSString *) (cFirstName);
    NSString *lastName = (__bridge_transfer NSString *) (cLastName);
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone, identifier);
    NSString *phoneNO = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phone, index);
    
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (phone && [phoneNO isKindOfClass:[NSString class]] && [phoneNO length] > 0)
    {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        
        if (self.contactCommand && self.contactCallback)
        {
            
            NSString *text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@ %@\\\",\\\"num\\\":\\\"%@\\\"}", firstName, lastName, phoneNO];
            if([QuickWebStringUtil isStringHasChineseCharacter:firstName])
            {
                text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@%@\\\",\\\"num\\\":\\\"%@\\\"}", lastName, firstName, phoneNO];
            }
            
            QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:self.contactCommand.secretId callbackId:self.contactCommand.callbackId resultWithString:text];
            self.contactCallback(result);
            self.contactCommand = nil;
            self.contactCallback = nil;
        }
        return NO;
    }
    return YES;
}

//iOS 9
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.contactCommand && self.contactCallback)
    {
        QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:NO secretId:self.contactCommand.secretId callbackId:self.contactCommand.callbackId resultWithDict:[NSDictionary dictionary]];
        self.contactCallback(result);
        self.contactCommand = nil;
        self.contactCallback = nil;
    }
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    //获取联系人姓名
    NSString *lastName = contact.familyName;
    NSString *firstName = contact.givenName;
    //数组保存各种类型的联系方式的字典（可以理解为字典） 字典的key和value分别对应号码类型和号码
    NSArray *phoneNums = contact.phoneNumbers;
    //通过遍历获取联系人各种类型的联系方式
    CNLabeledValue *labelValue = [phoneNums firstObject];
    //取出每一个字典，根据键值对取出号码和号码对应的类型
    NSString *phoneNO = [labelValue.value stringValue];
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([phoneNO isKindOfClass:[NSString class]] && [phoneNO length] > 0)
    {
        if (self.contactCommand && self.contactCallback)
        {
            
            NSString *text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@ %@\\\",\\\"num\\\":\\\"%@\\\"}", firstName, lastName, phoneNO];
            if([QuickWebStringUtil isStringHasChineseCharacter:firstName])
            {
                text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@%@\\\",\\\"num\\\":\\\"%@\\\"}", lastName, firstName, phoneNO];
            }
            
            QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:self.contactCommand.secretId callbackId:self.contactCommand.callbackId resultWithString:text];
            self.contactCallback(result);
            self.contactCommand = nil;
            self.contactCallback = nil;
        }
    }
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    //获取联系人信息
    NSString *lastName = contactProperty.contact.familyName;  //姓
    NSString *firstName = contactProperty.contact.givenName;    //名
    
    NSString *phoneNO = [contactProperty.value stringValue];  //号码
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([phoneNO isKindOfClass:[NSString class]] && [phoneNO length] > 0)
    {
        if (self.contactCommand && self.contactCallback)
        {
            
            NSString *text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@ %@\\\",\\\"num\\\":\\\"%@\\\"}", firstName, lastName, phoneNO];
            if([QuickWebStringUtil isStringHasChineseCharacter:firstName])
            {
                text = [NSString stringWithFormat:@"{\\\"name\\\":\\\"%@%@\\\",\\\"num\\\":\\\"%@\\\"}", lastName, firstName, phoneNO];
            }
            
            QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:self.contactCommand.secretId callbackId:self.contactCommand.callbackId resultWithString:text];
            self.contactCallback(result);
            self.contactCommand = nil;
            self.contactCallback = nil;
        }
    }
}

#pragma mark query contact private

- (void) queryContactByNumber:(NSString *)number
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    __weak typeof(self) weakSelf = self;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        if (@available(iOS 9.0, *))
        {
            //ios9 or later
            CNEntityType entityType = CNEntityTypeContacts;
            if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
            {
                CNContactStore * contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if(granted)
                    {
                        NSError* contactError;
                        CNContactStore* addressBook = [[CNContactStore alloc] init];
                        [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
                        if(![contactError isKindOfClass:[NSError class]])
                        {
                            NSString* queryResult = [weakSelf copyContact:addressBook queryNumber:number];
                            QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:self.queryContactCommand.secretId callbackId:self.queryContactCommand.callbackId resultWithString:queryResult];
                            if(weakSelf.queryContactCallback)weakSelf.queryContactCallback(result);
                            weakSelf.queryContactCommand = nil;
                            weakSelf.queryContactCallback = nil;
                        }
                        
                    }
                }];
            }
        }
        else
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                if(granted)
                {
                    CFErrorRef *error1 = NULL;
                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                    if(!error&& self.queryContactCallback && self.queryContactCommand)
                    {
                        NSString* queryResult = [weakSelf copyAddressBook:addressBook queryNumber:number];
                        QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:self.queryContactCommand.secretId callbackId:self.queryContactCommand.callbackId resultWithString:queryResult];
                        if(weakSelf.queryContactCallback)weakSelf.queryContactCallback(result);
                        weakSelf.queryContactCommand = nil;
                        weakSelf.queryContactCallback = nil;
                    }
                }
            });
        }
    }
    else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        NSString* queryResult = [self copyAddressBook:addressBook queryNumber:number];
        if(!error && self.queryContactCallback && self.queryContactCommand)
        {
            QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:self.queryContactCommand.secretId callbackId:self.queryContactCommand.callbackId resultWithString:queryResult];
            self.queryContactCallback(result);
            self.queryContactCommand = nil;
            self.queryContactCallback = nil;
        }
    }
    
    [self queryContactFailure];
    
}

-(void) queryContactFailure
{
    if(self.queryContactCallback && self.queryContactCommand)
    {
        QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:NO secretId:self.contactCommand.secretId callbackId:self.contactCommand.callbackId resultWithString:@""];
        self.queryContactCallback(result);
        self.queryContactCommand = nil;
        self.queryContactCallback = nil;
    }
}


-(NSString*) copyContact:(CNContactStore*) addressBook queryNumber:(NSString*)number
{
    NSError* contactError;
    NSMutableArray *contacts = [NSMutableArray new];
    NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
        NSString * firstName =  contact.givenName;
        NSString * lastName =  contact.familyName;
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        if([QuickWebStringUtil isStringHasChineseCharacter:firstName])
        {
            name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
        }
        NSArray * phones = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
        for (NSString *phone in phones) {
            NSString * phoneNO = phone;
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@" " withString:@""];
            [contacts addObject:@[name, phoneNO]];
        }
    }];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self[1] contains [cd] %@", number];
    
    NSArray *filterData = [[NSArray alloc] initWithArray:[contacts filteredArrayUsingPredicate:predicate]];
    
    NSMutableArray *resultArray = [NSMutableArray new];
    for (NSArray *array in filterData)
    {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"name"] = array[0];
        dict[@"num"] = array[1];
        [resultArray addObject:dict];
    }
    
    NSString *result = [QuickWebDataParseUtil toJSONString:resultArray];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    return result;
}

- (NSString*)copyAddressBook:(ABAddressBookRef)addressBook queryNumber:(NSString *)number
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *contacts = [NSMutableArray new];
    
    for (int i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        CFStringRef cFirstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef cLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        NSString *firstName = @"";
        
        if (cFirstName) {
            firstName = (__bridge_transfer NSString *) (cFirstName);
        }
        NSString *lastName = @"";
        if (cLastName) {
            lastName = (__bridge_transfer NSString *) (cLastName);
        }
        
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        if([QuickWebStringUtil isStringHasChineseCharacter:firstName])
        {
            name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
        }
        
        for (int j = 0;j < ABMultiValueGetCount(phone); j++)
            
        {
            NSString *phoneNO = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, j);
            
            if ([phoneNO hasPrefix:@"+"]) {
                phoneNO = [phoneNO substringFromIndex:3];
            }
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (phone && [phoneNO isKindOfClass:[NSString class]] && [phoneNO length] > 0) {
                
                [contacts addObject:@[name, phoneNO]];
            }
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self[1] contains [cd] %@", number];
    
    NSArray *filterData = [[NSArray alloc] initWithArray:[contacts filteredArrayUsingPredicate:predicate]];
    
    NSMutableArray *resultArray = [NSMutableArray new];
    for (NSArray *array in filterData)
    {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"name"] = array[0];
        dict[@"num"] = array[1];
        [resultArray addObject:dict];
    }
    
    NSString *result = [QuickWebDataParseUtil toJSONString:resultArray];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    return result;
}
@end
