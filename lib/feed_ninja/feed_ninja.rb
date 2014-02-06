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

  # get the feed and iterate over the entries
	def process
		@out = AtomIshWriter.new
    #TODO use @in.feed_type == "atom" / "rss"
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
        #FIXME that ain't gonna work exactly like that anymore, since image is now gonna be an array
				item.imgLink, item.text = extract original.link
			end
		end
	end

  # extract the specified elements from the entries provided by the feed

	def extract uri
		uri = uri.href if uri.respond_to? 'href'
		open(uri) do |site|
			doc = Nokogiri::HTML(site)
			return extract_image(doc, site.base_uri), extract_xml(doc)
		end
	end

	def extract_image doc, base
		Array(@picture_xpath).collect_concat do |xpath|
			doc.xpath(xpath).collect do | picture_src |
				if(picture_src.to_s.start_with? 'http') then
					picture_src.to_s
				else
					"#{base.scheme}://#{base.host}/#{base.path}#{picture_src}"
				end
			end
		end
	end

	def extract_xml doc
		Array(@text_xpath).collect do |xpath|
			doc.xpath(xpath).inject do | result, text_html |
				result.to_s + text_html.to_s
			end
    end.join("\n")
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

