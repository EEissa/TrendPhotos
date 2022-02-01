# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Photos' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'ESNetworkManager'
  pod 'ESNetworkManager/Rx'
  pod 'ESNetworkManager/ObjectMapper'
  pod "ViewAnimator"
  pod 'SnapKit', '~> 5.0.0'
  pod 'RxCocoa'
  pod 'RealmSwift', '=10.1.4'
  pod 'Kingfisher'
  pod 'SKPhotoBrowser'
  
  target 'PhotosTests' do
         inherit! :search_paths
         pod 'RxBlocking'
         pod 'RxTest'
  end

end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
