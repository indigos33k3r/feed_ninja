require 'spec_helper'
require 'feed_ninja'

describe AtomIshWriter do
  it 'should output a valid atom feed' do
    writer = AtomIshWriter.new
    writer.title = 'test'
    writer.link = 'http://example.com/atom'
    writer.updated = DateTime.now.to_s

    writer.new_entry(0) do |entry|
      entry = Entry.new
      entry.title = "title"
      entry.link = "http://example.com/one"
      entry.id = entry.link
      entry.images = ["http://example.com/one.jpg", "http://example.com/two.jpg"]
      entry.summary = "First part of the story"
      entry.updated = DateTime.now.to_s
    end

    writer.new_entry(1) do |entry|
      entry = Entry.new
      entry.title = "title"
      entry.link = "http://example.com/two"
      entry.id = entry.link
      entry.images = ["http://example.com/one.jpg", "http://example.com/two.jpg"]
      entry.summary = "Second part of the story"
      entry.updated = (DateTime.now - 60).to_s
    end

    RSS::Parser.parse(writer.to_s)
  end
end
