#
# Be sure to run `pod lib lint UXPhoneNumberInput.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UXPhoneNumberInput'
  s.version          = '1.0.0'
  s.summary          = 'UXPhoneNumberInput is a view controller for inputting phone number'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
UXPhoneNumberInput is a view controller for inputting phone number. It support country code selection and detection, also can format the phone number according to the selected country.
This view controller is useful for app that requires user's phone number for login, SMS verification, etc.
                       DESC

  s.homepage         = 'https://github.com/eddy-lau/UXPhoneNumberInput'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eddie Lau' => 'eddie@touchutility.com' }
  s.source           = { :git => 'https://github.com/eddy-lau/UXPhoneNumberInput.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.3'

  s.source_files = 'UXPhoneNumberInput/Classes/**/*'
  s.resource_bundles = {
    'UXPhoneNumberInput' => ["UXPhoneNumberInput/Resources/**/*.{storyboard,png,xcassets}"]
  }

  # s.resource_bundles = {
  #   'UXPhoneNumberInput' => ['UXPhoneNumberInput/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'PhoneNumberKit', '~> 1.2'
  s.dependency 'AJCountryPicker2', '~> 2.0'

end
