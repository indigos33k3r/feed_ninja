require 'rss'
require 'open-uri'
require 'nokogiri'
require 'time'

class FeedNinja
	attr_accessor :uri, :picture_xpath, :text_xpath, :title_regex, :limit

	def initialize (uri = nil)
    @uri = uri
		@limit = 2
	end

	def fetchFeed
		open(@uri) do |rss|
			@in = RSS::Parser.parse(rss)
		end
	end

	def process
		@out = AtomIshWriter.new
		@out.updated = DateTime.now.to_s
		if @in.respond_to? "channel" then
			@out.title = "N!#{@in.channel.title}"
			@out.link = @in.channel.link
		else
			@out.title = "N!#{@in.title.content}"
			@out.link = @in.link.href

		end

		i = 0
		@in.items.each do |original|
			next if title_regex and not title_regex =~ original.title
			break if i == limit
			i = i+1

			@out.new_entry do |item|
				item.originalLink = original.link
				item.title = original.title
				if original.respond_to? 'pubDate' then
					item.updated = original.pubDate.xmlschema
				else
					item.updated = original.updated
				end
				item.imgLink, item.text = extract original.link
			end
		end
	end

	def extract uri
		uri = uri.href if uri.respond_to? 'href'
		open(uri) do |site|
			doc = Nokogiri::HTML(site)
			return extractImage(doc, site.base_uri), extractText(doc)
		end
	end

	def extractImage doc, base
		if(@picture_xpath)
			doc.xpath(@picture_xpath).each do | ex |
				if(ex.to_s.start_with? 'http') then
					return ex
				else
					return "#{base.scheme}://#{base.host}/#{base.path}/#{ex}"
				end
			end
		end
	end

	def extractText doc
		if(@text_xpath)
			text = ''
			doc.xpath(@text_xpath).each do | ex |
				text = text + ex.to_s
			end
		end
		text
	end

	def output
		puts @out.to_s
	end

	def run
		fetchFeed
		process
		output
	end

  ## DSL convenience setters

  def picture_at xpath
    @picture_xpath = xpath
  end

  def text_at xpath
    @text_xpath = xpath
  end

  def title_matches regex
    @title_regex = regex
  end
end

