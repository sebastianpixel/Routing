Pod::Spec.new do |s|
  s.name         = 'Routing-SebastianPickl'
  s.module_name  = 'Routing'
  s.version      = '0.1.0'
  s.summary      = 'Minimal dynamic Router implementation'
  s.description  = <<-DESC
  Microframework for dynamic routing inside apps based on `Route` and `RouteHandler` types.
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
