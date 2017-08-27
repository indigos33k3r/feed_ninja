require 'webrick'
require 'nokogiri'
require 'feed_ninja'

class Ninja < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    response.body = with_captured_stdout do
      require_relative "./feeds#{request.path}"
    end
    response.status = 200
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



server = WEBrick::HTTPServer.new(:Port => 3000)
server.mount("/", Ninja)

trap("INT") {
  server.shutdown
}

server.start
