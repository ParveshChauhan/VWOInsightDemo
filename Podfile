# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'VWO Insights Demo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VWO Insights Demo
 pod 'SSZipArchive'
  pod 'SCLAlertView', '~> 0.8'
  pod 'MBProgressHUD', '~> 1.1.0'

# Add the Firebase pod for Google Analytics
pod 'FirebaseAnalytics'
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'Firebase/Core'
pod 'Firebase/Crashlytics'
pod 'VWO-Insights'

end

post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
           
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
                      
#          config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 14.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
            end
         end
     end
  end
