platform :ios, '13.0'

target 'HSMaster' do
  use_frameworks!

  # Architecture
  pod 'Katana', '~> 6.0'
  pod 'PinLayout', '~> 1.10'
  pod 'Tempura', '~> 9.0'
  
  # User Interface
  pod 'Kingfisher', '~> 7.0'
  pod 'SkeletonView', '~> 1.25'

  # Developer Tools
  pod 'SwiftGen', '~> 6.4'
  pod 'SwiftLint', '~> 0.44'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = 13.0
    end
  end
end
