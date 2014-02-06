require 'spec_helper'
require 'feed_ninja'

describe "extract" do
  before :each do
    @ninja = FeedNinja.new
  end

  it 'should extract one image with relative url' do
    @ninja.picture_at "//div[@id='one_image_relative']/img/@src"

    doc = Nokogiri::HTML(open 'spec/pages/one.html')

    picture = @ninja.extract_image(doc, URI('http://example.com'))

    picture.should == ["http://example.com/one.jpg"]
  end

  it 'should extract one image with absolute url' do
    @ninja.picture_at "//div[@id='one_image_absolute']/img/@src"

    doc = Nokogiri::HTML(open 'spec/pages/one.html')

    picture = @ninja.extract_image(doc, URI('http://example.com'))

    picture.should == ["http://example.org/one.jpg"]
  end

  it 'should extract several images' do
    @ninja.picture_at "//div[@id='several_images']/img/@src"
    doc = Nokogiri::HTML(open 'spec/pages/one.html')
    pictures = @ninja.extract_image(doc, URI('http://example.com'))

    pictures.size.should == 2
    pictures.should == ["http://example.com/one.jpg", "http://example.com/two.jpg"]
  end

  it 'should extract some paragraphs' do
    @ninja.text_at "//div[@id='paragraphs']/p"
    doc = Nokogiri::HTML(open 'spec/pages/one.html')
    paragraphs = @ninja.extract_xml doc

    paragraphs.should == "<p>one</p><p>two</p><p>three</p>"
  end
end

describe "ninja" do
  it 'should read an atom feed' do
    @ninja.uri = 'spec/feeds/atom.xml'
  end

  it 'should read an RSS feed' do
    @ninja.uri = 'spec/feeds/rss.xml'
  end
end
