platform :ios, '13.0'

target 'HSMaster' do
  use_frameworks!

  pod 'Katana', '~> 6.0'
  pod 'SwiftLint', '~> 0.44'
  pod 'Tempura', '~> 9.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = 13.0
    end
  end
end
