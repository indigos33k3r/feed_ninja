class AtomIshWriter
	attr_accessor :title, :link, :updated
	def initialize
		@entries = []
	end

	def new_entry
		item = Entry.new
		yield item
		@entries << item;
	end

	def to_s
		puts %{Content-type: text/html

<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

	<title>#{@title}</title>
	<id>#{@link}</id> 
	<link href="#{@link}"/>
	<updated>#{@updated}</updated>
	<author>
		<name>FeedNinja</name>
		<uri>http://github.com/Tourniquet/feedninja</uri>
		<email>latzer.daniel@gmail.com</email>
	</author>
}
		@entries.each do |entry| puts entry.to_s end

		puts "</feed>"

	end
end

class Entry
	attr_accessor :title, :imgLink, :originalLink, :updated, :text

	def to_s
		puts %{
  <entry>
    <title>#{@title}</title>
    <link rel="alternate" type="text/html" href="#{@imgLink}" />
    <id>#{@originalLink}</id>
    <updated>#{@updated}</updated>
    <content type="html">#{self.content.encode(:xml => :text)}</content>
	</entry>
		}
	end

	def title= title
		if title.respond_to? :content then
			@title = title.content
		else
			@title = title.to_s
		end
	end

	def originalLink= link
		if link.respond_to? :href then
			@originalLink = link.href
		else
			@originalLink = link.to_s
		end
	end

	def updated= elem
		if elem.respond_to? :content then
			@updated = elem.content
		else
			@updated = elem.to_s
		end
	end

	def content
		%{
			<a href="#{@originalLink}">
				<img src="#{@imgLink}"/>
			</a>
			#{@text}
		}
	end
end
