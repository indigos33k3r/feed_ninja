require "feed_ninja"

get "http://thenoobcomic.com/headquarters/rss/rss.xml" do
    picture_at "//div[@id='main_content_comic']/img/@src"
end

