# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def testing_pods
  pod 'Quick'
  pod 'Nimble'
end

target 'TravelBooks' do
  use_frameworks!

  pod 'Alamofire'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'SwiftLint'

  target 'TravelBooksTests' do
    inherit! :search_paths
    testing_pods
  end

  target 'TravelBooksUITests' do
    inherit! :search_paths
    testing_pods
  end
end
