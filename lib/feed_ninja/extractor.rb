require 'uri'
require 'open-uri'

class Extractor
  attr_accessor :doc

  def fetch uri
    open(uri) do |site|
      @doc = Nokogiri::HTML(site)
      #return extract_image(doc, site.base_uri), extract_xml(doc)
    end
  end

  def extract_images(base_url, xpaths)
    LOGGER.debug{ "collecting images for #{xpaths}" }
    xpaths.collect_concat do |xpath|
      LOGGER.debug{ "collecting image:xpath #{xpath}" }
      extract_image(URI(base_url), xpath)
    end
  end

  def extract_image(base_url, xpath)
    @doc.xpath(xpath).collect do | picture_src |
      if(picture_src.to_s.start_with? 'http') then
        picture_src.to_s
      else
        LOGGER.debug { "BASE URL IS #{base_url.class}" }
        "#{base_url.scheme}://#{base_url.host}/#{base_url.path}#{picture_src}"
      end
    end
  end

  def extract_xml(xpaths)
    LOGGER.debug{ "collecting text" }
    xpaths.collect_concat do |xpath|
      LOGGER.debug{ "collecting text:xpath #{xpath}" }
      @doc.xpath(xpath).collect do |result|
        LOGGER.debug{ "collecting text:result #{result}" }
        result.to_s
      end
    end
  end
end
