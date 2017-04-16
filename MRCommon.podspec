Pod::Spec.new do |s|

  s.name                 = "MRCommon"
  s.version              = "1.0.0"
  s.summary              = "iOS commonly used methods"
  s.homepage             = "https://github.com/MrReality/MRCommon"
  s.license              = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "刘入徵" => "573880506@qq.com" }
  s.platform             = :ios, "8.0"
  s.source               = { :git => "https://github.com/MrReality/MRCommon.git", :tag => s.version.to_s }
  s.source_files          = "MRCommon/**/*.{h,m}"
  s.requires_arc         = true
end