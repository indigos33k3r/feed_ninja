require 'spec_helper'
require 'feed_ninja'

describe Extractor do
  before :each do
    @extractor = Extractor.new
    @extractor.fetch 'spec/pages/one.html'
    @base = URI('http://example.com')
  end

  it 'should extract one image with relative url' do
    xpath = "//div[@id='one_image_relative']/img/@src"
    picture = @extractor.extract_images(@base, xpath)

    picture.should == ["http://example.com/one.jpg"]
  end

  it 'should extract one image with absolute url' do
    xpath = "//div[@id='one_image_absolute']/img/@src"
    base = URI('http://wrong.com') #base URI shouldn't be applied here
    picture = @extractor.extract_images(base, xpath)

    picture.should == ["http://example.com/one.jpg"]
  end

  it 'should extract several images' do
    xpath = "//div[@id='several_images']/img/@src"
    pictures = @extractor.extract_images(@base, xpath)

    pictures.size.should == 2
    pictures.should == ["http://example.com/one.jpg", "http://example.com/two.jpg"]
  end

  it 'should extract some paragraphs' do
    paragraphs = @extractor.extract_xml "//div[@id='paragraphs']/p"

    paragraphs.should == %w{<p>one</p> <p>two</p> <p>three</p>}
  end
end
