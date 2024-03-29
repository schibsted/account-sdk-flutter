#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'schibsted_account_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for Schibsted Account SDK'
  s.description      = <<-DESC
Flutter plugin for Schibsted Account SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'SchibstedAccount'

  s.ios.deployment_target = '9.0'
end

