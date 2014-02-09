require 'rss'
require 'open-uri'
require 'nokogiri'
require 'time'
require 'thread'
require 'thwait'

class FeedNinja
  attr_accessor :uri, :picture_xpath, :text_xpath, :title_regex, :limit

  def initialize
    @limit = 4
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
    threads = []
    items.first(@limit).each_with_index do |item, index|
      threads << Thread.new { process_item(item, doc.feed_type, index) }
    end
    ThreadsWait.all_waits(*threads)
  end

  def process_item(original, feed_type, index)
    @writer.new_entry(index) do |entry|
      extractor = Extractor.new
      case feed_type
      when "atom"
        entry.title = original.title.content
        entry.link = original.link.href
        entry.updated = original.updated
        entry.id = original.id
        extractor.fetch original.link.href
      when "rss"
        entry.title = original.title
        entry.link = original.link
        entry.updated = original.pubDate ? original.pubDate.xmlschema : DateTime.now.to_s
        entry.id = entry.link
        extractor.fetch original.link
      end

      entry.images = extractor.extract_images @picture_xpath
      entry.summary = extractor.extract_xml @text_xpath

      entry #it's kind of fishy to explicitly have to return the entry here...
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

