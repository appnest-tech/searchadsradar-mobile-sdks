Pod::Spec.new do |s|
  s.name             = 'searchadsradar'
  s.version          = '1.0.0'
  s.summary          = 'SearchAdsRadar SDK for Flutter - first-party Apple Search Ads attribution.'
  s.description      = <<-DESC
First-party Apple Search Ads attribution, StoreKit 2 revenue, sessions and
custom events. Contains the vendored SARKit native SDK - do not add SARKit
to the app separately. Requires iOS 16.0+.
  DESC
  s.homepage         = 'https://searchadsradar.com'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'AppNest' => 'support@searchadsradar.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'searchadsradar/Sources/searchadsradar/**/*.swift'
  s.resource_bundles = {
    'searchadsradar_privacy' => ['searchadsradar/Sources/searchadsradar/PrivacyInfo.xcprivacy']
  }
  s.dependency 'Flutter'
  s.platform         = :ios, '16.0'
  s.swift_version    = '5.9'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
