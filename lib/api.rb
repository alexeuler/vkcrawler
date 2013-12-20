require "socket"

module Vk
  class Api

    EOF='&<<!EOF'

  #def method_missing(method, *args, &block)
    #method.gsub!("_",".")
  #end

    def send(request)
      s=TCPSocket.new "localhost", 9000
      s.puts "#{request}\n#{EOF}"
      response=""
      while line=s.gets
        line.chomp!
        response << line
      end
      response
      s.close
    end

  end
end
