require 'feed_ninja'

get "http://www.tabletitans.com/feed" do
    title_matches /^Tales/
      text_at "//section[@class='tales']/article/p"
end
