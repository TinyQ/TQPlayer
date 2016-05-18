Pod::Spec.new do |s|
	s.name     = 'TQPlayer'
	s.version  = '0.0.1'
	s.license  = 'MIT'
	s.summary  = 'A video player base on AVPlayer.'
	s.homepage = 'https://github.com/tinyq/TQPlayer'
	s.authors  = { 'qfu' => 'tinyqf@gmail.com' }
	s.source   = { :git => 'https://github.com/tinyq/TQPlayer.git', :tag => s.version, :submodules => true }
	s.requires_arc = true
	
	s.source_files = 'TQPlayer/TQPlayer.{h,m}'
	s.public_header_files = 'TQPlayer/*.{h}'
	
	s.ios.deployment_target = '8.0'
	s.platform = :ios
	
	s.subspec 'PlayerView' do |ss|
		ss.source_files = 'TQPlayer/PlayerView/*.{h,m}'
		ss.public_header_files = 'TQPlayer/PlayerView/*.{h}'
	end

	s.subspec 'PanelView' do |ss|
		ss.source_files = 'TQPlayer/PanelView/*.{h,m}'
		ss.public_header_files = 'TQPlayer/PanelView/*.{h}'
	end
	
	s.subspec 'Helper' do |ss|
		ss.source_files = 'TQPlayer/Helper/*.{h,m}'
		ss.public_header_files = 'TQPlayer/Helper/*.{h}'
	end
	
	s.subspec 'Resources' do |ss|
		ss.source_files = 'TQPlayer/Resources/*.{h,m}'
		ss.public_header_files = 'TQPlayer/Resources/*.{h}'
		ss.resource = 'TQPlayer/Resources/TQPlayer.bundle'
	end
	
	s.frameworks = 'UIKit', 'CoreFoundation'
end

