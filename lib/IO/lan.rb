require_relative "web"

class VK
  module IO
    class Lan

      attr_accessor :socket, :thread

      def initialize(args={})
        args=defaults.merge(args)
        @host=args[:host]
        @port=args[:port]
        @web=args[:web]
        @thread=nil
        @socket=nil
        start
      end

      def start
        server=TCPServer.new(@host,@port)
        @thread=Thread.new do
          while true do
            process_request(server)
          end
        end
      end

      def process_response(response)
        socket.puts response
        socket.close
        Thread.exit
      end

      private

      def process_request(server)
        Thread.new(server.accept) do |client|
          this=self.dup
          this.socket=client
          requests=[]
          while request=client.gets do
            @web.push request: requests, respond_to: this
          end
        end
      end

      def defaults
        {host: 'localhost', port: 9000}
      end

    end
  end
end
