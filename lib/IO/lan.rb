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
        @socket=nil
        @requests_number=0
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
        Thread.new(server.accept) do |socket|
          @socket=socket
          requests=read_requests(socket)
          push_requests(requests)
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

      def push_requests(requests) 
        this=self.clone
        this.requests_number=0
        this.requests_number=requests.length
        requests.each {|request| @web.push request: request, respond_to: this}
      end

      def defaults
        {host: 'localhost', port: 9000}
      end

    end
  end
end
