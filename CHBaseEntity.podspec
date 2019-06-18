

#



Pod::Spec.new do |s|
  s.name             = 'CHBaseEntity'
  s.version          = '0.1.2'
  s.summary          = 'Entity解析工具，基于YYModel 1.0.4'
 ription      = <<-DESC
Entity解析工具，基于YYModel 1.0.4，外部使用的时候Entity类继承自CHBaseEntity即可
                       DESC

  s.homepage         = 'https://github.com/lichanghong/CHBaseEntity.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1211054926@qq.com' => 'lichanghong' }
  s.source           = { :git => 'https://github.com/lichanghong/CHBaseEntity.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'CHBaseEntity/Classes/**/*'
 
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'YYModel', '1.0.4'
end
