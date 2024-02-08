#
# Be sure to run `pod lib lint WTLibrary-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'WTLibrary-iOS'
s.version          = '0.4.5'
s.summary          = 'summary with WTLibrary-iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
TODO: Add long description of the pod here.
A simple life with WTLibrary-iOS.
DESC

s.homepage         = 'https://github.com/wtanuw/WTLibrary-iOS'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'wtanuw' => 'wat_wtanuw@hotmail.com' }
s.source           = { :git => 'https://github.com/wtanuw/WTLibrary-iOS.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

#s.ios.deployment_target = '9.0'
s.ios.deployment_target = '12.0' # 231218 + xcode 14.2
s.osx.deployment_target = '10.12'

# s.source_files = 'WTLibrary-iOS/Classes/**/*'
# s.ios.source_files   = 'CoordinatorType-iOS/*.swift'
# s.osx.source_files   = 'CoordinatorType-macOS/*.swift'

# s.resource_bundles = {
#   'WTLibrary-iOS' => ['WTLibrary-iOS/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'

s.default_subspec = 'WTObjC'


##################################################

s.subspec 'WTObjC' do |subspec|
subspec.source_files = 'WTLibrary-iOS/Classes/WT*.{h,m}'
subspec.frameworks = 'QuartzCore'
end

##################################################20240110

s.subspec 'OCProgress' do |subspec|
subspec.source_files = 'WTLibrary-iOS/Library/OCProgress/*.{h,m}'
subspec.requires_arc = false
subspec.frameworks = 'UIKit'
end

##################################################

s.subspec 'AQGridViewHorizontal' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/AQGridViewHorizontal/*.{h,m}'
subspec.frameworks = 'UIKit', 'QuartzCore'
end

##################################################

s.subspec 'CategoriesExtension' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/CategoriesExtension/*.{h,m}'
subspec.frameworks = 'UIKit', 'QuartzCore'
end

##################################################

s.subspec 'CategoriesExtensionMD5' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/CategoriesExtensionMD5/*.{h,m}'
end

##################################################

s.subspec 'KLCPopup' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/KLCPopup/*.{h,m}'
end

##################################################

s.subspec 'MetadataRetriever' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/MetadataRetriever/*.{h,m}'
subspec.frameworks = 'AudioToolbox', 'AssetsLibrary', 'AVFoundation'
end

##################################################

s.subspec 'WTDatabase' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.dependency 'FMDB', '~> 2.0'
subspec.source_files = 'WTLibrary-iOS/Classes/WTDatabase/*.{h,m}'
end

##################################################

s.subspec 'WTDropbox' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
#subspec.dependency 'ObjectiveDropboxOfficial', '3.9.1'
subspec.dependency 'ObjectiveDropboxOfficial', '7.0.0'
subspec.source_files = 'WTLibrary-iOS/Classes/WTDropbox/*.{h,m}'
end

##################################################

s.subspec 'WTDropbox6' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
#subspec.dependency 'ObjectiveDropboxOfficial', '3.9.1'
subspec.dependency 'ObjectiveDropboxOfficial', '6.0.0'
subspec.source_files = 'WTLibrary-iOS/Classes/WTDropbox/*.{h,m}'
end

##################################################

#use with use_frameworks!
s.subspec 'WTGoogle1' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.dependency 'GoogleAPIClientForREST/Drive', '~> 1.1.1'
subspec.dependency 'GTMOAuth2', '~> 1.1.4'
subspec.dependency 'GTMSessionFetcher', ' 1.3.0'
subspec.dependency 'GTMAppAuth', '~> 0.7.0'
#subspec.dependency 'Google/SignIn' //4.2.0
subspec.source_files = 'WTLibrary-iOS/Classes/WTGoogle1/*.{h,m}'
subspec.vendored_frameworks = ['WTLibrary-iOS/Classes/WTGoogle1/GoogleAppUtilities.framework', 'WTLibrary-iOS/Classes/WTGoogle1/GoogleSignIn.framework', 'WTLibrary-iOS/Classes/WTGoogle1/GoogleSignInDependencies.framework', 'WTLibrary-iOS/Classes/WTGoogle1/GoogleSymbolUtilities.framework']
subspec.resource = 'WTLibrary-iOS/Classes/WTGoogle1/GoogleSignIn.bundle'
subspec.frameworks = 'SafariServices', 'SystemConfiguration', 'GoogleAppUtilities', 'GoogleSignIn', 'GoogleSignInDependencies', 'GoogleSymbolUtilities'

#subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'LIBRARY_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks"', 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks"', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks"' }
#subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks", "${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle"' }
#subspec.header_dir = '{PODS_ROOT}/../../WTLibrary-iOS/Classes/WTGoogle'

#subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle" "${PODS_ROOT}/../../WTLibrary-iOS/Classes/WTGoogle"' }
subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle1" "${PODS_ROOT}/../../WTLibrary-iOS/Classes/WTGoogle1" "~/Desktop/Wat/WTLibrary/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle1"', 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle1"' }
end

##################################################

s.subspec 'WTGoogle' do |subspec|
#subspec.ios.deployment_target = '11.0'
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.dependency 'GoogleAPIClientForREST/Drive', '~> 1.6.0' # drive
#subspec.dependency 'GTMOAuth2', '~> 1.1.4'
#subspec.dependency 'GTMSessionFetcher'
subspec.dependency 'GTMAppAuth' ,'~> 1.2.2' # login
subspec.dependency 'GoogleSignIn', '~> 6.1'
subspec.source_files = 'WTLibrary-iOS/Classes/WTGoogle/*.{h,m}'
#subspec.vendored_frameworks = ['WTLibrary-iOS/Classes/WTGoogle/GoogleAppUtilities.framework', 'WTLibrary-iOS/Classes/WTGoogle/GoogleSignIn.framework', 'WTLibrary-iOS/Classes/WTGoogle/GoogleSignInDependencies.framework', 'WTLibrary-iOS/Classes/WTGoogle/GoogleSymbolUtilities.framework']
#subspec.resource = 'WTLibrary-iOS/Classes/WTGoogle/GoogleSignIn.bundle'
#subspec.frameworks = 'SafariServices', 'SystemConfiguration', 'GoogleAppUtilities', 'GoogleSignIn', 'GoogleSignInDependencies', 'GoogleSymbolUtilities'

#subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'LIBRARY_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks"', 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks"', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks"' }
#subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/GoogleSignIn/Frameworks", "${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle"' }
#subspec.header_dir = '{PODS_ROOT}/../../WTLibrary-iOS/Classes/WTGoogle'

#subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle" "${PODS_ROOT}/../../WTLibrary-iOS/Classes/WTGoogle"' }
#subspec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle" "${PODS_ROOT}/../../WTLibrary-iOS/Classes/WTGoogle" "~/Desktop/Wat/WTLibrary/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle"', 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/WTLibrary-iOS/WTLibrary-iOS/Classes/WTGoogle"' }
end

##################################################

s.subspec 'WTLocation' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/WTLocation/*.{h,m}'
end

##################################################

s.subspec 'WTSNS' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/WTSNS/*.{h,m}'
subspec.frameworks = 'Twitter', 'Social', 'Accounts'
end

##################################################

s.subspec 'WTStoreKit' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.dependency 'Reachability', '~> 3.2'
subspec.dependency 'WTLibrary-iOS/CategoriesExtension'
subspec.source_files = 'WTLibrary-iOS/Classes/WTStoreKit/*.{h,m}'
subspec.frameworks = 'StoreKit', 'Security'
end

##################################################

s.subspec 'WTSwipeModalView' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.dependency 'AGWindowView', '~> 0.1'
subspec.source_files = 'WTLibrary-iOS/Classes/WTSwipeModalView/*.{h,m}'
end

##################################################

s.subspec 'WTUIKit' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/WTUIKit/*.{h,m}'
subspec.frameworks = 'UIKit', 'QuartzCore'
end

##################################################

s.subspec 'WTUtaPlayer' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.source_files = 'WTLibrary-iOS/Classes/WTUtaPlayer/*.{h,m}'
subspec.frameworks = 'AVFoundation', 'MediaPlayer'
end

##################################################

s.subspec 'WTSwift' do |subspec|
#  subspec.dependency 'AFDateHelper', '~> 4.1'
  subspec.dependency 'AFDateHelper', '~> 4.3'
subspec.source_files = 'WTLibrary-iOS/Swift/*'
subspec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end

##################################################

s.subspec 'WTRuntime' do |subspec|
subspec.source_files = 'WTLibrary-iOS/Classes/WTRuntime/*.{h,m}'
subspec.dependency 'WTLibrary-iOS/WTObjC'
#subspec.dependency 'CHCSVParser', '~> 2.1'
#subspec.dependency 'SBJson', '~> 5.0'
subspec.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '"SAVEPATH=@\"$(PROJECT_DIR)\""' }
end

##################################################

s.subspec 'WTiOS' do |subspec|
subspec.source_files = 'WTLibrary-iOS/Classes/WTiOS/*.{h,m}'
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.frameworks = 'UIKit', 'QuartzCore'
end

##################################################

s.subspec 'WTmacOS' do |subspec|
subspec.source_files = 'WTLibrary-iOS/Classes/WTmacOS/*.{h,m}'
subspec.dependency 'WTLibrary-iOS/WTObjC'
end

##################################################

s.subspec 'WTIncrement' do |subspec|
#    no source files, resources, resource_bundles, preserve paths, vendored_libraries, vendored_frameworks, dependencies, nor subspecs
    subspec.dependency 'WTLibrary-iOS/WTObjC'
#s.ios.script_phase = {
#    :name => 'WTSubIncrement',
#    :script => '
#echo "INFOPLIST_FILE PODS_TARGET_SRCROOT is  "    "${PODS_TARGET_SRCROOT}/$INFOPLIST_FILE"
#echo "INFOPLIST_FILE INFOPLIST_FILE is  "    "$INFOPLIST_FILE"
#buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
#buildNumber=$(($buildNumber + 1))
#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"',
#    :execution_position => :after_compile
#}
end

##################################################

#s.subspec 'WTAppName' do |subspec|
#s.script_phase = { :name => 'WTAppName', :script => 'echo "Hello World"' }
#end

##################################################

s.subspec 'WTMetal' do |subspec|
subspec.dependency 'WTLibrary-iOS/WTObjC'
subspec.dependency 'EZAudio', '1.1.5'
subspec.frameworks = 'Metal', 'MetalKit', 'AVFoundation'
subspec.source_files = 'WTLibrary-iOS/Classes/WTMetal/*.{h,m}'
end

##################################################20240129

s.subspec 'WTVolumeView' do |subspec|
subspec.source_files = 'WTLibrary-iOS/Classes/WTVolumeView/WT*.{h,m}'
subspec.resource = 'WTLibrary-iOS/Classes/WTVolumeView/WT*.{storyboard}', 'WTLibrary-iOS/Classes/WTVolumeView/*.{xcassets}'
subspec.frameworks = 'QuartzCore'
end

##################################################

end
