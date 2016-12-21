#
# Be sure to run `pod lib lint MOPhoneNumberInputViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MOPhoneNumberInputViewController'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MOPhoneNumberInputViewController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/MOPhoneNumberInputViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eddie Lau' => 'eddie@touchutility.com' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/MOPhoneNumberInputViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.3'

  s.source_files = 'MOPhoneNumberInputViewController/Classes/**/*'
  s.resource_bundles = {
    'MOPhoneNumberInputViewController' => ["MOPhoneNumberInputViewController/Resources/**/*.{storyboard,png,xcassets}"]
  }

  # s.resource_bundles = {
  #   'MOPhoneNumberInputViewController' => ['MOPhoneNumberInputViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'PhoneNumberKit', '~> 1.2'
  s.dependency 'AJCountryPicker2', '~> 2.0'

end
