Pod::Spec.new do |s|
    s.name             = "QuickWebKit"
    s.version          = "2.0.5"
    s.summary          = "A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。"
    s.description      = <<-DESC
    A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。如果您仅想使用其中部分(而非全部插件)，您可以根据需要仅安装您需要的功能与插件， 该项目支持 Cocoapods 的 subspec。
    DESC
    s.homepage         = "https://github.com/pcjbird/QuickWebKit"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/QuickWebKit.git", :tag => s.version.to_s}
    s.social_media_url = 'https://www.lessney.com'
    s.requires_arc     = true
    s.documentation_url = 'https://github.com/pcjbird/QuickWebKit/blob/master/README.md'
    s.screenshot       = 'https://github.com/pcjbird/QuickWebKit/raw/master/logo.png'

    s.platform         = :ios, '8.0'
    s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'WebKit', 'JavaScriptCore' ,'QuartzCore', 'MobileCoreServices', 'CoreSpotlight'
#s.preserve_paths   = ''
    s.source_files     = 'QuickWebKit/QuickWebKit.h'

    s.dependency 'SmartJSWebView'
    s.dependency 'YYImage/WebP'
    s.dependency 'YYWebImage'
    s.dependency 'Popover.OC'

    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
    
    s.xcconfig = {
        'VALID_ARCHS' =>  'armv7 armv7s x86_64 arm64',
    }

    s.subspec 'QuickWebViewController' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebKit.h', 'QuickWebKit/QuickWebKitDefines', 'QuickWebKit/QuickWebUtil', 'QuickWebKit/QuickWebCore'
        ss.public_header_files = 'QuickWebKit/QuickWebKit.h', 'QuickWebKit/QuickWebCore/*.{h}'
        ss.resource_bundles = {
            'QuickWebKit' => ['QuickWebBundles/QuickWebKitBundle/*.{png,lproj}'],
        }
    end

    s.subspec 'QuickWebToastPlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebToastPlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebToastPlugin/*.{h}'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.dependency 'Toast'
    end

    s.subspec 'QuickWebProviderPlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebProviderPlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebProviderPlugin/QuickWebProviderPlugin.h'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.resource_bundles = {
        'QuickWebProviderPlugin' => ['QuickWebBundles/QuickWebProviderPluginBundle/*.lproj'],
        }
    end

    s.subspec 'QuickWebSharePlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebSharePlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebSharePlugin/QuickWebSharePlugin.h'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.dependency 'EasyShareKit'
        ss.dependency 'GTMNSStringHTMLAdditions'
    end

    s.subspec 'QuickWebQRCodePlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebQRCodePlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebQRCodePlugin/QuickWebQRCodePlugin.h'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.dependency 'ZXingObjC'
        ss.dependency 'Toast'
    end

   s.subspec 'QuickWebLNRefreshPlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebLNRefreshPlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebLNRefreshPlugin/QuickWebLNRefreshPlugin.h'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.dependency 'LNRefresh'
    end

    s.subspec 'QuickWebMJRefreshPlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebMJRefreshPlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebMJRefreshPlugin/QuickWebMJRefreshPlugin.h'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.dependency 'MJRefresh'
    end

    s.subspec 'QuickWebSpotlightPlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebSpotlightPlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebSpotlightPlugin/QuickWebSpotlightPlugin.h'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.dependency 'EasyShareKit'
        ss.dependency 'GTMNSStringHTMLAdditions'
        ss.dependency 'YYCategories'
    end

    s.subspec 'QuickWebJSBridgePlugin' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin'
        ss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/*.{h}'
        ss.dependency 'QuickWebKit/QuickWebViewController'
        ss.dependency 'Toast'
        ss.resource_bundles = {
            'QuickWebJSBridgePlugin' => ['QuickWebBundles/QuickWebJSBridgePluginBundle/*.lproj'],
        }

        ss.subspec 'QuickWebJSBridgeSystemProxy' do |sss|
            sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeSystemProxy.{h,m}'
            sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeSystemProxy.{h}'
            sss.dependency 'QuickWebKit/QuickWebViewController'
        end

        ss.subspec 'QuickWebJSBridgeAccountProxy' do |sss|
            sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeAccountProxy.{h,m}'
            sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeAccountProxy.{h}'
            sss.dependency 'QuickWebKit/QuickWebViewController'
        end

        ss.subspec 'QuickWebJSBridgeContactProxy' do |sss|
            sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeContactProxy.{h,m}'
            sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeContactProxy.{h}'
            sss.frameworks = 'AddressBookUI', 'AddressBook', 'ContactsUI'
            sss.dependency 'QuickWebKit/QuickWebViewController'
        end

        ss.subspec 'QuickWebJSBridgeNavBarProxy' do |sss|
            sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeNavBarProxy.{h,m}'
            sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeNavBarProxy.{h}'
            sss.dependency 'QuickWebKit/QuickWebViewController'
        end

        ss.subspec 'QuickWebJSBridgeShareProxy' do |sss|
            sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeShareProxy.{h,m}'
            sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/CoreProxies/QuickWebJSBridgeShareProxy.{h}'
            sss.dependency 'QuickWebKit/QuickWebViewController'
        end

        ss.subspec 'QuickWebJSBridgeImagePlayProxy' do |sss|
            sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/ExtProxies/QuickWebJSBridgeImagePlayProxy.{h,m}'
            sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/ExtProxies/QuickWebJSBridgeImagePlayProxy.{h}'
            sss.dependency 'QuickWebKit/QuickWebViewController'
            sss.dependency 'IDMPhotoBrowser'
        end

        ss.subspec 'QuickWebJSBridgeVideoPlayProxy' do |sss|
            sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/ExtProxies/QuickWebJSBridgeVideoPlayProxy.{h,m}'
            sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/ExtProxies/QuickWebJSBridgeVideoPlayProxy.{h}'
            sss.dependency 'QuickWebKit/QuickWebViewController'
            sss.dependency 'ZFPlayer/AVPlayer', '~> 3.1.8'
            sss.dependency 'ZFPlayer/ControlView', '~> 3.1.8'
        end

        ss.subspec 'QuickWebJSBridgePushMessageProxy' do |sss|
        sss.source_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/ExtProxies/QuickWebJSBridgePushMessageProxy.{h,m}'
        sss.public_header_files = 'QuickWebKit/QuickWebPlugins/QuickWebJSBridgePlugin/Proxies/ExtProxies/QuickWebJSBridgePushMessageProxy.{h}'
        sss.dependency 'QuickWebKit/QuickWebViewController'
        end
    end

end
