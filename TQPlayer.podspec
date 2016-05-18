Pod::Spec.new do |s|
	s.name     = 'TQPlayer'
	s.version  = '0.0.1'
	s.license  = 'MIT'
	s.summary  = 'A video player base on AVPlayer.'
	s.homepage = 'https://github.com/tinyq/TQPlayer'
	s.authors  = { 'qfu' => 'tinyqf@gmail.com' }
	s.source   = { :git => 'https://github.com/tinyq/TQPlayer.git', :tag => s.version}
	s.requires_arc = true
	s.ios.deployment_target = '8.0'
	s.platform = :ios, '8.0'
	
	s.source_files = 'TQPlayer/*.{h,m}'
	s.public_header_files = 'TQPlayer/*.{h}'
	s.resource = 'TQPlayer/TQPlayer.bundle'
	s.frameworks = 'UIKit', 'CoreFoundation', 'CoreTelephony', 'AVFoundation', 'QuartzCore'
end

