require 'uri'
require 'open-uri'
require 'open_uri_redirections'

class Extractor
  attr_accessor :doc

  def fetch uri
    open(URI(uri), :allow_redirections => :all) do |site|
      @doc = Nokogiri::HTML(site)
      @base_uri = site.base_uri
      #return extract_image(doc, site.base_uri), extract_xml(doc)
    end
  end

  def extract_images(xpaths)
    LOGGER.debug{ "collecting images for #{xpaths}" }
    [*xpaths].collect_concat do |xpath|
      LOGGER.debug{ "collecting image:xpath #{xpath}" }
      extract_image(xpath)
    end
  end

  def extract_image(xpath)
    @doc.xpath(xpath).collect do | picture_href |
      URI.join(@base_uri, picture_href)
    end
  end

  def extract_xml(xpaths)
    LOGGER.debug{ "collecting text" }
    [*xpaths].collect_concat do |xpath|
      LOGGER.debug{ "collecting text:xpath #{xpath}" }
      @doc.xpath(xpath).collect do |result|
        LOGGER.debug{ "collecting text:result #{result}" }
        result.to_s
      end
    end
  end
end
