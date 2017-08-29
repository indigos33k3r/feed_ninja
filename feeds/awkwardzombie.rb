#!/usr/bin/env ruby

require "feed_ninja"

get "http://awkwardzombie.com/awkward.php" do
  picture_at '//*[@id="comic"]/img/@src'
  text_at '//*[@id="blarg"]'
end
