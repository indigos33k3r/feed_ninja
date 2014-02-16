require 'rake'

Gem::Specification.new do |s|
  s.name              = "feed_ninja"
  s.version           = "0.0.4"
  s.date              = '2014-02-16'
  s.platform          = Gem::Platform::RUBY
  s.author           = "Daniel Latzer"
  s.email             = "latzer.daniel@gmail.com"
  s.homepage          = "http://github.com/tourniquet/feedninja"
  s.summary           = "A tiny helper to rip the interesting bits out of RSS and Atom feeds"
  s.description       = "This gem can be used to take an RSS or Atom feed, follow the links they provide and extract images and/or text with xpath. The data is then reformatted into a new Atom feed.
It is inteded to be used with feeds that only provide a sneak peek of the content, to rip all the interesting bits out for displaying in your feed reader immediately."
  s.files             = Dir['README.md', 'lib/**/*' ,'spec/**/*']
  s.licenses          = 'MIT'

  s.require_path = 'lib'

  s.add_development_dependency 'rspec', "= 2.14.1"
  s.add_runtime_dependency 'nokogiri', "= 1.6.1"
end
