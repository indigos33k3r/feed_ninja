require 'webrick'
require 'nokogiri'
require 'feed_ninja'

class Ninja < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    begin
      response.body = with_captured_stdout do
        load File.expand_path(File.dirname(__FILE__)) + "/feeds#{request.path}"
      end
      response.header['Content-type'] = 'application/atom+xml'

      response.status = 200
    rescue LoadError
      response.status = 404
    end
  end
end

def with_captured_stdout
  old_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = old_stdout
end



server = WEBrick::HTTPServer.new(:Port => ENV['PORT'])
server.mount("/", Ninja)

trap("INT") {
  server.shutdown
}

server.start
