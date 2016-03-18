#
# Be sure to run `pod lib lint Louis.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Louis"
  s.version          = "1.0.3"
  s.summary          = "Automated Accessibility Testing for iOS."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
Automated Accessibility Testing for iOS. Run automatically while your app is running or manually as part of your view tests. Easily control how the results are reported.
                       DESC

  s.homepage         = "https://github.com/aleffert/Louis"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Akiva Leffert" => "aleffert@gmail.com" }
  s.source           = { :git => "https://github.com/aleffert/Louis.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/aleffert'

  s.requires_arc = true

  s.platform     = :ios, '8.0'
  s.source_files = 'Sources/*.{h,m}'

  # s.public_header_files = 'Sources/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
