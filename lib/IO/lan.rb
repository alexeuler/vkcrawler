require_relative 'tuple'
require_relative 'logger'
require 'socket'


module Vk
  module IO
    class Lan
      include Logger
      EOF='xHvh58vuUU'


      def initialize(args={})
        args=defaults.merge(args)
        @host=args[:host]
        @port=args[:port]
        @requests=args[:requests]
        @responses=args[:responses]
        @server=nil
        start
      end

      def start
        start_server
        listen
        respond
      end

      private

      def listen
        Thread.new do
          while true
            Thread.new(@server.accept) do |socket|
              requests=read_requests(socket)
              counter=requests.count
              requests.each do |request|
                t=Tuple.new data: request, socket: socket, counter: counter
                log.info request
                @requests.push t
              end
              Thread.exit
            end
          end
        end
      end

      def respond
        Thread.new do
          while true
            write_response
          end
        end
      end

      def write_response
        tuple=@responses.pop
        tuple.socket.write tuple.data
        tuple.counter-=1
        tuple.socket.close if tuple.counter==0
      end

      def read_requests(socket)
        requests=[]
        while request=socket.gets do
          request.chomp!
          break if request == EOF
          requests << request
        end
        log.info "Fetched requests: #{requests}"
        requests
      end

      def start_server
        begin
          @server=TCPServer.new(@host,@port)
          log.info "Server started on #{@host}:#{@port}"
        rescue Exception => e
          log.error "Class #{self.class} was unable to start server on #{@host}:#{@port}. Error: #{e.message}"
          raise e
        end
      end


      def defaults
        {host: "localhost", port: 9000}
      end


    end
  end
end


