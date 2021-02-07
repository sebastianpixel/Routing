Pod::Spec.new do |s|
  s.name         = 'Routing-SebastianPickl'
  s.module_name  = 'Routing'
  s.version      = '0.1.0'
  s.summary      = 'Strongly typed routing concept without static navigation flows.'
  s.description  = <<-DESC
Router is based on the idea of open navigation flows where any location inside an app can be reached from anywhere by passing instances of `Route` types to corresponding, preregistered `RouteHandler`s. While `Route`s provide necessary information about the desination, `RouteHandler`s will provide instances of a generic `View` type which can be specified as `AnyView`, `UIViewController`, `NSViewController` or any other type.
DESC
  s.homepage     = 'https://github.com/sebastianpixel/Routing'
  s.authors            = 'Sebastian Pickl'
  s.social_media_url   = 'https://twitter.com/SebastianPickl'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.swift_versions = '5.3'
  s.frameworks = ['UIKit']
  s.ios.deployment_target  = '9.0'
  s.source       = { :git => 'https://github.com/sebastianpixel/Routing.git', :tag => "#{s.version}" }
  s.source_files  = 'Sources/Routing/**/*.swift'
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/RoutingTests'
  end
end
