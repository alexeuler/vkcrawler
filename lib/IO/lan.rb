require_relative "web"

class VK
  module IO
    class Lan

      attr_accessor :socket, :thread, :requests_number

      EOF='&<<!EOF'

      def initialize(args={})
        args=defaults.merge(args)
        @host=args[:host]
        @port=args[:port]
        @web=args[:web]
        @thread=nil
        @socket=nil
        @requests_number=0
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
        socket.puts response+"\n"+EOF
        @requests_number-=1
        if @requests_number==0
          socket.close
          Thread.exit
        end
      end

      private

      def process_request(server)
        Thread.new(server.accept) do |client|
          
          this=self.clone
          this.socket=client
          this.requests_number=0
          requests=[]

          while request=client.gets.chomp do
            break if request == EOF
            requests << request
          end
          
          this.requests_number=requests.length
          requests.each {|request| @web.push request: request, respond_to: this}
        end
      end

      def defaults
        {host: 'localhost', port: 9000}
      end

    end
  end
end
