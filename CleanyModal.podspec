#
# Be sure to run `pod lib lint CleanyModal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CleanyModal'
  s.version          = '1.0.0'
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
  s.screenshots      = 'https://user-images.githubusercontent.com/3198863/38334725-77f10d24-385c-11e8-9e94-89d653628748.png', 'https://user-images.githubusercontent.com/3198863/38334726-780677b8-385c-11e8-9d69-ca5950520252.png', 'https://user-images.githubusercontent.com/3198863/38334727-7820f070-385c-11e8-9aa3-d49bf9262a39.png', 'https://user-images.githubusercontent.com/3198863/44787753-4c670a00-ab98-11e8-869e-a219c82633c0.jpeg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'loryhuz' => 'lory.huz@gmail.com' }
  s.source           = { :git => 'https://github.com/loryhuz/CleanyModal.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/LoryHuz'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'CleanyModal/Classes/**/*'
end
