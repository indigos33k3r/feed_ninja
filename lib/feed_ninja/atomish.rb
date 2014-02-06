class AtomIshWriter
  attr_accessor :title, :link, :updated
  def initialize
    @entries = []
  end

  def new_entry
    item = Entry.new
    item = yield item
    @entries << item;
  end

  def to_s
    %{<?xml version="1.0" encoding="utf-8"?>
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
    #{@entries.inject { |memo, entry| memo.to_s + entry.to_s }.to_s}</feed>}

  end
end

class Entry
  attr_accessor :title, :link, :images, :updated, :summary, :id

  def to_s
    %{  <entry>
    <title>#{@title}</title>
    <link rel="alternate" type="text/html" href="#{@link}" />
    <id>#{@id}</id>
    <updated>#{@updated}</updated>
    <content type="html">#{self.content.encode(:xml => :text)}</content>
  </entry>
}
  end

  def content
    Array(@images).inject("") do |memo, src|
      memo += %{
      <a href="#{src}">
        <img src="#{src}"/>
      </a>
      }
    #end + summary || ""
    end
  end
end
