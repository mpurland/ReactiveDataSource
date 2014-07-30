#
# Be sure to run `pod lib lint ReactiveDataSource.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ReactiveDataSource"
  s.version          = "0.1.0"
  s.summary          = "ReactiveCocoa extensions for data sources."
  s.description      = <<-DESC
                       ReactiveCocoa extensions for data sources that apply to UITableView, UITableViewController, UICollectionView, UICollectionViewController, etc.
                       DESC
  s.homepage         = "https://github.com/mpurland/ReactiveDataSource"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Matthew Purland" => "m.purland@gmail.com" }
  s.source           = { :git => "https://github.com/mpurland/ReactiveDataSource.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mpurland'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/ios'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'QuartzCore'
  
  s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'ReactiveCocoa', '~> 2.3'
  s.dependency 'libextobjc/EXTScope', '~> 0.4'
end
