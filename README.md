#Feed Ninja

##Example Usage
  require 'ninja'

  get 'http://example.com/rss' do
    picture_at '//foo/img/@src'
    text_at '//bar/span'
    title_matches /^News/
  end
