Pod::Spec.new do |s|
  s.name             = "Bidali-iOS-SDK"
  s.version          = "0.0.1"
  s.summary          = "Drop in Commerce SDK"
  s.description      = <<-DESC
  	This SDK enables cryptocurrency wallets to allow users to purchase in-app.
                       DESC
  s.homepage         = "https://bidali.com"
  s.license          = 'MIT'
  s.author           = { "Bidali" => "support@bidali.com" }
  s.source           = { git: "https://github.com/bidalihq/commerce-ios-sdk.git", tag: s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.dependency       "WebViewJavascriptBridge", "~> 6.0"
  s.source_files 	 = "Bidali.*/*.{h,m}"
  s.frameworks 		 = "UIKit", "WebKit"
end
