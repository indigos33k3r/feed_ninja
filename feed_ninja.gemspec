Gem::Specification.new do |s|
  s.name              = "feed_ninja"
  s.version           = "0.0.1"
  s.date              = '2014-02-04'
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Daniel Latzer"]
  s.email             = "latzer.daniel@gmail.com"
  s.homepage          = "http://github.com/tourniquet/feedninja"
  s.summary           = "A tiny helper to rip the interesting bits out of RSS and Atom feeds"

  s.files             = FileList['lib/*'].to_a
  s.licenses          = ['MIT']

  s.require_path = 'lib'

  s.add_runtime_dependency 'nokogiri'
end
