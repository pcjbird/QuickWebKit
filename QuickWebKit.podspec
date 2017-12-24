Pod::Spec.new do |s|
    s.name             = "QuickWebKit"
    s.version          = "1.0.0"
    s.summary          = "A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。"
    s.description      = <<-DESC
    A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。
    DESC
    s.homepage         = "http://www.lessney.com"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/QuickWebViewController.git", :tag => s.version.to_s}
    s.social_media_url = 'https://github.com/pcjbird/QuickWebViewController'
    s.requires_arc     = true
#s.documentation_url = ''
#s.screenshot       = ''

    s.platform         = :ios, '8.0'
    s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'WebKit', 'JavaScriptCore' ,'QuartzCore'
#s.preserve_paths   = ''
    s.source_files     = 'QuickWebKit/QuickWebKit.h'

    s.dependency 'SmartJSWebView'

    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

    s.subspec 'QuickWebViewController' do |ss|
        ss.source_files = 'QuickWebKit/QuickWebKit.h', 'QuickWebKit/QuickWebKitDefines', 'QuickWebKit/QuickWebUtil', 'QuickWebKit/QuickWebCore'
        ss.public_header_files = 'QuickWebKit/QuickWebKit.h', 'QuickWebKit/QuickWebCore/*.{h}'
        ss.resource_bundles = {
            'QuickWebKit' => ['QuickWebResources/QuickWebViewControllerResource/*.*'],
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
        'QuickWebProviderPlugin' => ['QuickWebResources/QuickWebProviderPluginResource/*.*'],
        }
    end

end
