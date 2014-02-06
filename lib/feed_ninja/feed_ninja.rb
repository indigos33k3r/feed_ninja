require 'rss'
require 'open-uri'
require 'nokogiri'
require 'time'

class FeedNinja
  attr_accessor :uri, :picture_xpath, :text_xpath, :title_regex, :limit
  attr_accessor :extractor

  def initialize
    @limit = 2
    @extractor = Extractor.new
    @writer = AtomIshWriter.new
    @ninja_prefix = "N! "
  end

  def initialize_writer doc
    @writer.updated = DateTime.now.to_s

    case doc.feed_type
    when "atom"
      @writer.title = @ninja_prefix + doc.title.content
      @writer.link = doc.link.href
    when "rss"
      @writer.title = @ninja_prefix + doc.channel.title
      @writer.link = doc.channel.link
    else
      raise "Invalid feed format"
    end
  end

  # get the feed and iterate over the entries
  def fetch url
    open(url) do |feed|
      doc = RSS::Parser.parse(feed)
      initialize_writer(doc)
      process_items(doc)
    end
  end

  def process_items doc
    items = doc.items
    if title_regex
      items = items.select { |item| title_regex =~ item.title }
    end
    items.first(@limit).each do |item|

      #TODO add multithreading here; be sure to use multiple extractor instances
      process_item item, doc.feed_type
    end
  end

  def process_item original, feed_type
    @writer.new_entry do |entry|
      case feed_type
      when "atom"
        entry.title = original.title.content
        entry.link = original.link.href
        entry.updated = original.updated
        entry.id = original.id
      when "rss"
        entry.title = original.title
        entry.link = original.link
        entry.updated = original.pubDate ? original.pubDate.xmlschema : DateTime.now.to_s
        entry.id = entry.link
      end

      @extractor.fetch original.link
      entry.images = @extractor.extract_images @picture_xpath
      entry.summary = @extractor.extract_xml @text_xpath
    end
  end

  def to_s
    @writer.to_s
  end

  ## DSL convenience setters

  def picture_at *xpath
    @picture_xpath = xpath
  end

  def text_at *xpath
    @text_xpath = xpath
  end

  def title_matches regex
    @title_regex = regex
  end
end

