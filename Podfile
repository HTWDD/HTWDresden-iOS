# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

def common_pods
  # RX Swift
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Action'
  
  # Serial- Deserialization
  pod 'Marshal', '~> 1.2', :inhibit_warnings => true
  
  # Protected Safe Passwords
  pod 'KeychainAccess'
  
  # R.Swift -> Generating Strong Typed Resources
  pod 'R.swift'
  
  # Networking
  pod 'Moya'

  # Realm Database
  pod 'RealmSwift'
  pod 'RxRealm', :inhibit_warnings => true
  
  # Keychain Wrapper
  pod 'SwiftKeychainWrapper'
end

target 'HTWDD' do
  common_pods
  
  # Firebase
  pod 'Firebase/Analytics'
  
  # Pods for PodTest
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  
  # Side Menu
  pod 'SideMenu'
  
  # TabMan
  pod 'Tabman', '~> 2.4', :inhibit_warnings => true
  
  # Lottie
  pod 'lottie-ios'
  
  #ImageView
  pod 'ImageScrollView'
  
  target 'HTWDDTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'HTWDD Today' do
  common_pods
end
