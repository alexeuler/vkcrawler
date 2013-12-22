module Vk
  module IO

    EOF='xHvh58vuUU'

    class ResponseHandler

      def initialize(args)
        @socket=args[:socket]
        @number=args[:number]
      end

      def handle_response(response)
        log "Response handler called. Response: #{response[0..20]}..."
        @socket.puts "#{response}\n#{EOF}"
        @number-=1
        if @number==0
          @socket.close
        end
      end
      
      def log(data)
        puts "#{Time.now} - #{data}"
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
        log "Constructor called"
      end

      def start
        begin
          server=TCPServer.new(@host,@port)
          log "Server started on #{@host}:#{@port}"
        rescue Exception => e
          log "Class #{self.class} was unable to start server on #{@host}:#{@port}. Error: #{e.message}"
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
          log "Fetched requests: #{requests}"
          respond_to=ResponseHandler.new(socket: socket, number: requests.count)
          requests.each {|r| @web.push request: r, respond_to: respond_to}
          Thread.exit
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

      def log(data)
        t=Time.now
        ms=(t.to_f*1000).to_i % 1000
        puts "#{t} #{ms}ms - #{data}"
      end

    end
  end
end
