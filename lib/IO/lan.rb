class VK
  module IO

    EOF='&<<!EOF'

    class ResponseHandler

      def initialize(args)
        @socket=args[:socket]
        @number=args[:number]
      end

      def handle_response(response)
        @socket.puts response+"\n"+EOF
        @number-=1
        if @number==0
          @socket.close
          Thread.exit
        end
      end

    end

    class Lan

      def initialize(args={})
        args=defaults.merge(args)
        @host=args[:host]
        @port=args[:port]
        @web=args[:web]
        start
      end

      def start
        server=TCPServer.new(@host,@port)
        Thread.new do
          while true 
            process_request(server)
          end
        end
      end


      private

      def process_request(server)
        Thread.new(server.accept) do |socket|
          requests=read_requests(socket)
          respond_to=ResponseHandler.new(socket: socket, number: requests.count)
          requests.each {|r| @web.push request: r, respond_to: respond_to}
        end
      end
      
      def read_requests(socket)
        requests=[]
        while request=socket.gets do
          request.chomp!
          break if request == EOF
          requests << request
        end
        requests
      end

      def defaults
        {host: 'localhost', port: 9000}
      end

    end
  end
end
