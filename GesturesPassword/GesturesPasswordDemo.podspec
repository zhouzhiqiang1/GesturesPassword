Pod::Spec.new do |s|

  s.name         = "GesturesPassword"

  s.version      = "0.0.2"

  s.homepage      = 'https://guides.cocoapods.org/making/private-cocoapods.html'

  s.ios.deployment_target = '8.0'

  s.summary      = "Gestures Passwordt"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "zhouzhiqiang1" => "zhou83955@sina.com" }

  s.source       = { :git => "https://github.com/zhouzhiqiang1/GesturesPassword.git", :tag => s.version }

  s.source_files  = "Gesture/*.{h,m,xib}"

  s.resource_bundles = {
    'GesturesPasswordDemo' => ['Gesture/*.{xib,png}']
  }

  s.requires_arc = true
 

end
