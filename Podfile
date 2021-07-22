platform :ios, '10.0'
source 'https://github.com/CocoaPods/Specs.git'

# ignore all warnings from all pods
inhibit_all_warnings!

use_frameworks!

def common_pods
  # RX Swift
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Action'
  
  # Serial- Deserialization
  pod 'Marshal', '~> 1.2'
  
  # Protected Safe Passwords
  pod 'KeychainAccess'
  
  # R.Swift -> Generating Strong Typed Resources
  pod 'R.swift'
  
  # Networking
  pod 'Moya', '~> 13.0.1'

  # Realm Database
  pod 'RealmSwift'
  pod 'RxRealm'
  
  # Keychain Wrapper
  pod 'SwiftKeychainWrapper'
end

target 'HTWDD' do
  common_pods
  
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  
  # TabMan
  pod 'Tabman'
  
  # Lottie
  pod 'lottie-ios'
  
  #ImageView
  pod 'ImageScrollView'
  
  #Timetable WeekView
  pod 'JZCalendarWeekView'
  
  target 'HTWDDTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'HTWDD Today' do
  common_pods
end
