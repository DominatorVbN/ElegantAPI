Pod::Spec.new do |s|
  s.name             = 'ElegantAPI'
  s.version          = '0.0.9'
  s.summary          = 'An URSessionDataTaskPublisher abstraction layer inspired by [Moya](https://github.com/Moya/Moya).'
  s.swift_versions   = '5.0'
  s.homepage         = 'https://github.com/DominatorVbN/ElegantAPI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Amit Samant' => 'voilentbynature@gmail.com' }
  s.source           = { :git => 'https://github.com/DominatorVbN/ElegantAPI.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/ElegantAPI/**/*.swift'
end
