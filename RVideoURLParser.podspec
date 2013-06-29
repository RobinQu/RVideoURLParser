Pod::Spec.new do |s|
  s.name         = "RVideoURLParser"
  s.version      = "0.0.1"
  s.summary      = "Video Parser for online video providers."
  s.homepage     = "https://github.com/RobinQu/RVideoURLParser"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "RobinQu" => "robinqu@gmail.com" }
  s.source       = { :git => "https://github.com/RobinQu/RVideoURLParser.git", :tag => "#{s.version}" }


  s.platform     = :ios, '5.0'
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'

  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 1.3.0'
end
