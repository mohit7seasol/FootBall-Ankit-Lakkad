# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Football' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Football

pod "IQKeyboardManagerSwift"
  pod "Toaster"
  pod "SDWebImage"
  pod 'Alamofire'
  pod "SwiftyJSON"
  pod 'ProgressHUD'
  pod 'SVProgressHUD'
  pod 'SwiftyStoreKit'
  pod 'Google-Mobile-Ads-SDK'
  pod 'MBProgressHUD'
  pod 'AWSMobileClient', '~> 2.6.13'
  pod 'AWSS3'
  pod "SkeletonView"
  pod 'NVActivityIndicatorView'
  pod 'lottie-ios'
  pod 'MarqueeLabel'
  pod 'FirebaseAnalytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Performance'
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.1'
        end
      end
    end
  end

end
