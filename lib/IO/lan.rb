class VK
  module IO

    EOF='&<<!EOF'

    class ResponseHandler

      def initialize(args)
        @socket=args[:socket]
        @number=args[:number]
      end

      def handle_response(response)
        @socket.puts "#{response}\n#{EOF}"
        @number-=1
        if @number==0
          @socket.close
          Thread.exit
        end
      end

    end

    class Lan

      # Protocol
      # Request - separated with  \n, EOF - end of transmission
      # Response - separated with EOF, socket close - end of transmission

      def initialize(args={})
        args=defaults.merge(args)
        @host=args[:host]
        @port=args[:port]
        @web=args[:web]
        start
      end

      def start
        begin
          server=TCPServer.new(@host,@port)
        rescue Exception => e
          puts "Class #{self.class} was unable to start server on #{@host}:#{@port}. Error: #{e.message}"
          raise e
        end
        Thread.new do
          while true 
            process_requests(server)
          end
        end
      end


      private

      def process_requests(server)
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
