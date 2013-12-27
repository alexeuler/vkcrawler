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
        @frequency=args[:frequency]
        @server=nil
        @last_fetch=Time.now
        start
      end

      def start
        start_server
        start_listening
        start_responding
      end

      private

      def start_listening
        Thread.new do
          while true
            Thread.new(@server.accept) do |socket|
              requests=read_requests(socket)
              counter=requests.count
              socket_struct=Tuple::SocketStruct.new socket: socket, counter: counter
              requests.each do |request|
                t=Tuple.new data: request, socket_struct: socket_struct
                delay
                @requests.push t
              end
              Thread.exit
            end
          end
        end
      end

      def start_responding
        Thread.new do
          while true
            write_response
          end
        end
      end

      def write_response
        tuple=@responses.pop
        socket=tuple.socket_struct.socket
        socket.puts tuple.data
        socket.puts EOF
        tuple.socket_struct.finished
        tuple.socket_struct.socket.close if tuple.socket_struct.close?
      end

      def read_requests(socket)
        requests=[]
        request=""
        while line=socket.gets do
          if line.chomp==EOF
            requests << request
            request=""
          else
            request << line.chomp 
          end
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

      def delay
        since_last_fetch=Time.now-@last_fetch # in seconds
        pause=[(@frequency-since_last_fetch).round(4), 0].max
        sleep(pause) unless pause==0
        @last_fetch=Time.now
      end

      def defaults
        {frequency: 0.2}
      end


      def defaults
        {host: "localhost", port: 9000, frequency: 0.2}
      end


    end
  end
end


