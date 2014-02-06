#FeedNinja
This gem can be used to take an RSS or Atom feed, follow the links they provide and extract images and/or text with xpath. The data is then reformatted into a new Atom feed.
It is inteded to be used with feeds that only provide a sneak peek of the content, to rip all the interesting bits out for displaying in your feed reader immediately.

##Example Usage
  require 'feed_ninja'

  get 'http://example.com/rss' do
    picture_at '//foo/img/@src'
    text_at '//bar/span'
    title_matches /^News/
  end
