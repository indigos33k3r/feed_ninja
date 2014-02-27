require 'spec_helper'
require 'feed_ninja'

describe FeedNinja do
  before :each do
    @ninja = FeedNinja.new
    @extractor = double()
    Extractor.should_receive(:new).and_return(@extractor)
    #Extractor.stub(:extract_images => [])
    #Extractor.stub(:extract_xml => "")
  end

  it 'should read an atom feed' do
    Extractor.should_receive(:new).exactly(3).times
    @ninja.fetch 'spec/feeds/atom.xml'
  end

  it 'should read an RSS feed' do
    Extractor.should_receive(:new).exactly(3).times
    @ninja.fetch 'spec/feeds/rss.xml'
  end

  it 'should not read more than the given limit', :focus do
    @ninja.limit = 1
    @extractor.should_receive(:fetch)
    @ninja.fetch './spec/feeds/rss.xml'
  end
end
