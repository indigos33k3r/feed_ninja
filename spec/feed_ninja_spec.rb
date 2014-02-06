require 'spec_helper'
require 'feed_ninja'

describe FeedNinja do
  before :each do
    @ninja = FeedNinja.new
    @extractor = double()
    @ninja.extractor = @extractor
    @extractor.stub(:extract_images)
    @extractor.stub(:extract_xml)
  end

  it 'should read an atom feed' do
    @extractor.should_receive(:fetch).twice
    @ninja.fetch 'spec/feeds/atom.xml'
  end

  it 'should read an RSS feed' do
    @extractor.should_receive(:fetch).twice
    @ninja.fetch 'spec/feeds/rss.xml'
  end

  it 'should not read more than the given limit' do
    @ninja.limit = 1
    @extractor.should_receive(:fetch).once
    @ninja.fetch 'spec/feeds/rss.xml'
  end
end
