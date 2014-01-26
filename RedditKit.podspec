Pod::Spec.new do |s|
  s.name         = "RedditKit"
  s.version      = "1.0.3"
  s.summary      = "An Objective-C wrapper for the reddit API."
  s.homepage     = "https://github.com/samsymons/RedditKit"
  s.social_media_url = "https://twitter.com/sam_symons"
  s.license      = 'MIT'
  s.authors      = { "Sam Symons" => "sam@samsymons.com", "Joe Pintozzi" => "joseph@pintozzi.com" }
  s.source       = { :git => "https://github.com/pyro2927/RedditKit.git", :branch => "master" }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Classes/*.{h,m}', 'Classes/**/*.{h,m}' 
  s.header_mappings_dir =  'Classes'

  s.dependency 'AFNetworking', '~> 2.1'
  s.dependency 'Mantle', '~> 1.3'
end
