class Extractor
  attr_accessor :doc

  def fetch uri
    open(uri) do |site|
      @doc = Nokogiri::HTML(site)
      #return extract_image(doc, site.base_uri), extract_xml(doc)
    end
  end

  def extract_images(base_url, *xpaths)
    Array(xpaths).collect_concat do |xpath|
      extract_image(base_url, xpath)
    end
  end

  def extract_image(base_url, xpath)
    @doc.xpath(xpath).collect do | picture_src |
      if(picture_src.to_s.start_with? 'http') then
        picture_src.to_s
      else
        "#{base_url.scheme}://#{base_url.host}/#{base_url.path}#{picture_src}"
      end
    end
  end

  def extract_xml *xpaths
    Array(xpaths).collect_concat do |xpath|
      @doc.xpath(xpath).collect do |result|
        result.to_s
      end
    end
  end
end
