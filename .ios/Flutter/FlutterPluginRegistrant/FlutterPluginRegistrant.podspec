#
# Generated file, do not edit.
#

Pod::Spec.new do |s|
  s.name             = 'FlutterPluginRegistrant'
  s.version          = '0.0.1'
  s.summary          = 'Registers plugins with your flutter app'
  s.description      = <<-DESC
Depends on all your plugins, and provides a function to register them.
                       DESC
  s.homepage         = 'https://flutter.dev'
  s.license          = { :type => 'BSD' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.ios.deployment_target = '8.0'
  s.source_files =  "Classes", "Classes/**/*.{h,m}"
  s.source           = { :path => '.' }
  s.public_header_files = './Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'cloud_firestore'
  s.dependency 'connectivity'
  s.dependency 'device_apps'
  s.dependency 'firebase_analytics'
  s.dependency 'firebase_auth'
  s.dependency 'firebase_core'
  s.dependency 'firebase_messaging'
  s.dependency 'firebase_storage'
  s.dependency 'flutter_account_kit'
  s.dependency 'flutter_facebook_login'
  s.dependency 'flutter_webview_plugin'
  s.dependency 'fluttertoast'
  s.dependency 'google_maps_flutter'
  s.dependency 'image_picker'
  s.dependency 'location'
  s.dependency 'notification_permissions'
  s.dependency 'path_provider'
  s.dependency 'rate_my_app'
  s.dependency 'share'
  s.dependency 'shared_preferences'
  s.dependency 'sqflite'
  s.dependency 'uni_links'
  s.dependency 'url_launcher'
end
