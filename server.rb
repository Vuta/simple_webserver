require 'socket'

class SimpleServer
  PORT = 8080

  attr_reader :server

  def initialize
    @server = TCPServer.new(PORT)
    puts "Server is ready..."
  end

  def start
    while true
      session = server.accept

      begin
        handle_success(session)
      rescue
        handle_not_found(session)
      end

      session.close
    end
  end

  private

  def handle_success(session)
    request = session.gets
    puts request

    _http_method, request_path, _http_version = request.split
    file = File.open("#{Dir.pwd}#{request_path}", 'r')

    session.print "HTTP/1.1 200 OK\r\n"
    session.print "\r\n"

    file.each_line do |line|
      session.print "#{line}"
    end
  end

  def handle_not_found(session)
    session.print "HTTP/1.1 404 Not Found\r\n"
    session.print "\r\n"
    session.print "Not Found"
  end
end

SimpleServer.new.start
