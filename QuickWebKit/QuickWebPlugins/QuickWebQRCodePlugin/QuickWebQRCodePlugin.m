//
//  QuickWebQRCodePlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebQRCodePlugin.h"
#import "QuickWebKitDefines.h"
#import "QuickWebStringUtil.h"
#import "QuickWebKit.h"
#import <Toast/Toast.h>
#import <ZXingObjC/ZXingObjC.h>

#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebQRCodePlugin class]] pathForResource:@"QuickWebKit" ofType:@"bundle"]]
@interface QuickWebQRCodePlugin()<UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    NSString*        _touchedImageUrl;
    NSString*        _resultQRCode;
    NSString*        _touchedLinkUrl;
}

@property(nonatomic, weak) QuickWebViewController*  targetWebController;
@end

@implementation QuickWebQRCodePlugin

-(instancetype)init
{
    if(self = [super init])
    {
        [self initVariables];
    }
    return self;
}

-(void) initVariables
{
    _touchedImageUrl = nil;
    _resultQRCode = nil;
    _touchedLinkUrl = nil;
}

-(NSString *)name
{
    return @"QuickWebQRCodePlugin";
}

-(void)setName:(NSString *)name
{
    
}

-(void)webViewControllerDidWebViewCreated:(QuickWebViewController *)webViewController
{
    [self initVariables];
    self.targetWebController = webViewController;
    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtap:)];
    longtapGesture.delegate = self;
    [webViewController.webView.scrollView addGestureRecognizer:longtapGesture];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if([self.targetWebController isKindOfClass:[QuickWebViewController class]])
    {
        CGPoint pt = [touch locationInView:self.targetWebController.webView.webView];
        [self prepareContextMenu:pt];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(![self.targetWebController isKindOfClass:[QuickWebViewController class]]) return NO;
    SmartJSWebView *webView = self.targetWebController.webView;
    if(![webView isKindOfClass:[SmartJSWebView class]])return NO;
    CGPoint pt = [gestureRecognizer locationInView:self.targetWebController.webView.webView];
    __block BOOL bResult = NO;
    [webView evaluateJavaScript:[NSString stringWithFormat:@"SmartJSGetHTMLElementsAtPoint(%li,%li);",(long)pt.x,(long)pt.y] completionHandler:^(id result, NSError *error) {
        NSString *tags = result;
        if ([tags rangeOfString:@",A,"].location != NSNotFound || [tags rangeOfString:@",IMG,"].location != NSNotFound)
        {
            bResult = YES;
            return;
        }
        bResult = NO;
    }];
    return bResult;
}

-(void)longtap:(UILongPressGestureRecognizer * )longtapGes
{
    
    if (longtapGes.state == UIGestureRecognizerStateBegan)
    {
        CGPoint pt = [longtapGes locationInView:self.targetWebController.webView.webView];
        [self openContextMenuAt:pt];
    }
    else if(longtapGes.state == UIGestureRecognizerStateEnded)
    {
        SmartJSWebView *webView = self.targetWebController.webView;
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='';" completionHandler:nil];
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='';" completionHandler:nil];
    }
}

-(void) prepareContextMenu:(CGPoint)pt
{
    if(![self.targetWebController isKindOfClass:[QuickWebViewController class]]) return;
    SmartJSWebView *webView = self.targetWebController.webView;
    if(![webView isKindOfClass:[SmartJSWebView class]])return;
    [webView evaluateJavaScript:[NSString stringWithFormat:@"SmartJSGetHTMLElementsAtPoint(%li,%li);",(long)pt.x,(long)pt.y] completionHandler:^(id result, NSError *error) {
        NSString *tags = result;
        if ([tags rangeOfString:@",A,"].location != NSNotFound || [tags rangeOfString:@",IMG,"].location != NSNotFound)
        {
            [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
            [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
            return;
        }
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='';" completionHandler:nil];
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='';" completionHandler:nil];
    }];
}


- (void)openContextMenuAt:(CGPoint)pt
{
    if(![self.targetWebController isKindOfClass:[QuickWebViewController class]]) return;
    SmartJSWebView *webView = self.targetWebController.webView;
    if(![webView isKindOfClass:[SmartJSWebView class]])return;
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:[NSString stringWithFormat:@"SmartJSGetHTMLElementsAtPoint(%li,%li);",(long)pt.x,(long)pt.y] completionHandler:^(id result, NSError *error) {
        NSString *tags = result;
        if ([tags rangeOfString:@",A,"].location != NSNotFound || [tags rangeOfString:@",IMG,"].location != NSNotFound)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            if ([tags rangeOfString:@",A,"].location != NSNotFound)
            {
                NSString *str = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
                [webView evaluateJavaScript:str completionHandler:^(id result, NSError *error) {
                    _touchedLinkUrl = result;
                    
                    //打开链接
                    UIAlertAction *openLinkAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OpenLink", @"Localizable", SDK_BUNDLE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBREQUESTURLHANDLERNOTIFICATION object:_touchedLinkUrl];
                        _resultQRCode = nil;
                        _touchedImageUrl = nil;
                        _touchedLinkUrl = nil;
                    }];
                    [alertController addAction:openLinkAction];
                    //在Safari中打开
                    UIAlertAction *openInSafariAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OpenInSafari", @"Localizable", SDK_BUNDLE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_touchedImageUrl ? _touchedImageUrl : _touchedLinkUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                        _resultQRCode = nil;
                        _touchedImageUrl = nil;
                        _touchedLinkUrl = nil;
                    }];
                    [alertController addAction:openInSafariAction];
                    
                }];
            }
            else if ([tags rangeOfString:@",IMG,"].location != NSNotFound)
            {
                //保存图片
                UIAlertAction *saveImageAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"SaveImage", @"Localizable", SDK_BUNDLE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_touchedImageUrl]]];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    imageView.backgroundColor = [UIColor whiteColor];
                    [imageView setContentMode:UIViewContentModeScaleToFill];
                    UIGraphicsBeginImageContext(imageView.bounds.size);
                    if (IsiOS7Later) {
                        [imageView drawViewHierarchyInRect:imageView.layer.bounds afterScreenUpdates:YES];
                    }
                    else
                    {
                        [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
                    }
                    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    UIImageWriteToSavedPhotosAlbum(result, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    _resultQRCode = nil;
                    _touchedImageUrl = nil;
                    _touchedLinkUrl = nil;
                }];
                [alertController addAction:saveImageAction];
                
                
                NSString *str = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
                [webView evaluateJavaScript:str completionHandler:^(id result, NSError *error) {
                    _touchedImageUrl = result;
                    NSString* imgStr = result;
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]]];
                    CGImageRef imageToDecode = image.CGImage;  // Given a CGImage in which we are looking for barcodes
                    
                    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
                    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
                    
                    NSError *qrerror = nil;
                    
                    // There are a number of hints we can give to the reader, including
                    // possible formats, allowed lengths, and the string encoding.
                    ZXDecodeHints *hints = [ZXDecodeHints hints];
                    
                    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
                    ZXResult *qrresult = [reader decode:bitmap hints:hints error:&qrerror];
                    if (qrresult)
                    {
                        // The coded result as a string. The raw data can be accessed with
                        // result.rawBytes and result.length.
                        NSString *contents = qrresult.text;
                        
                        // The barcode format, such as a QR code or UPC-A
                        ZXBarcodeFormat format = qrresult.barcodeFormat;
                        NSString *formatString = [weakSelf barcodeFormatToString:format];
                        NSString *display = [NSString stringWithFormat:@"识别到二维码，格式: %@ 内容:\n%@", formatString, contents];
                        SDK_LOG(@"%@",display);
                        _resultQRCode = qrresult.text;
                        
                        //识别二维码
                        UIAlertAction *decodeQRCodeAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"DecodeQRCode", @"Localizable", SDK_BUNDLE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBREQUESTURLHANDLERNOTIFICATION object:_resultQRCode];
                            _resultQRCode = nil;
                            _touchedImageUrl = nil;
                            _touchedLinkUrl = nil;
                        }];
                        [alertController addAction:decodeQRCodeAction];
                    }
                    else
                    {
                        // Use error to determine why we didn't get a result, such as a barcode
                        // not being found, an invalid checksum, or a format inconsistency.
                        SDK_LOG(@"无法识别当前二维码。");
                    }
                    //在Safari中打开
                    UIAlertAction *openInSafariAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OpenInSafari", @"Localizable", SDK_BUNDLE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_touchedImageUrl ? _touchedImageUrl : _touchedLinkUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                        _resultQRCode = nil;
                        _touchedImageUrl = nil;
                        _touchedLinkUrl = nil;
                    }];
                    [alertController addAction:openInSafariAction];
                }];
                
            }
            
            //取消
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Cancel", @"Localizable", SDK_BUNDLE, nil) style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            
            alertController.view.tintColor =  [weakSelf alertTintColor];
            [weakSelf.targetWebController presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
}


#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if ([error isKindOfClass:[NSError class]])
    {
        NSString *errorMsg = error.localizedDescription;
        if (![QuickWebStringUtil isStringBlank:errorMsg])
        {
            [self.targetWebController.view makeToast:errorMsg];
        }
        return;
    }
}

-(UIColor *) alertTintColor
{
    return [UIColor colorWithRed:(0x49)/255.f green:(0x49)/255.f blue:(0x4a)/255.f alpha:1.f];
}
@end
