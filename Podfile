# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

def common_pods
  # RX Swift
  pod 'RxSwift'
  pod 'RxCocoa'
  
  # Serial- Deserialization
  pod 'Marshal', '~> 1.2'
  
  # Protected Safe Passwords
  pod 'KeychainAccess'
  
  # R.Swift -> Generating Strong Typed Resources
  pod 'R.swift'
  
  # Networking
  pod 'Moya'

  # Realm Database
  pod 'RealmSwift'
end

target 'HTWDD' do
  common_pods
  
  # Side Menu
  pod 'SideMenu'

  target 'HTWDDTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'HTWDD Today' do
  common_pods
end
