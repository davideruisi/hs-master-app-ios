platform :ios, '14.0'

target 'HSMaster' do
  use_frameworks!

  # Architecture
  pod 'HydraAsync', '~> 2.0'
  pod 'Katana', '~> 6.0'
  pod 'PinLayout', '~> 1.10'
  pod 'Tempura', '~> 9.0'
  
  # Back-end Services
  pod 'Contentful', '~> 5.5'
  
  # User Interface
  pod 'Kingfisher', '~> 7.0'
  pod 'SkeletonView', '~> 1.25'

  # Tools
  pod 'SwiftLint', '~> 0.44'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = 14.0
    end
  end
end
