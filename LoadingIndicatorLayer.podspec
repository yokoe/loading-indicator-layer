#
# Be sure to run `pod lib lint LoadingIndicatorLayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LoadingIndicatorLayer'
  s.version          = '0.0.5'
  s.summary          = 'A CALayer based loading indicator.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A lightweight loading indicator with animations using CALayer.
                       DESC

  s.homepage         = 'https://github.com/yokoe/loading-indicator-layer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sota Yokoe' => 'info@kreuz45.com' }
  s.source           = { :git => 'https://github.com/yokoe/loading-indicator-layer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.osx.deployment_target = '10.9'

  s.source_files = 'Sources/**/*.swift'

  # s.resource_bundles = {
  #   'LoadingIndicatorLayer' => ['LoadingIndicatorLayer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.swift_version = '4.2'
end
