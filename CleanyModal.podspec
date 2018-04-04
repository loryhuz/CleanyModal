#
# Be sure to run `pod lib lint CleanyModal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CleanyModal'
  s.version          = '0.1.0beta'
  s.summary          = 'Swift UI Kit to present clean alert/modal'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Swift UI Kit to help to present clean and beautiful modal/alert in your iOS apps
                       DESC

  s.homepage         = 'https://github.com/loryhuz/CleanyModal'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'loryhuz' => 'lory.huz@gmail.com' }
  s.source           = { :git => 'https://github.com/loryhuz/CleanyModal.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/LoryHuz'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CleanyModal/Classes/**/*'
  s.resources = 'CleanyModal/Classes/*.xib'
  
  # s.resource_bundles = {
  #   'CleanyModal' => ['CleanyModal/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
