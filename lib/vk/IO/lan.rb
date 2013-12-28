require_relative 'tuple'
require_relative 'logger'
require_relative 'protocol'
require 'socket'


module Vk
  module IO
    class Lan
      include Logger

      def initialize(args={})
        args=defaults.merge(args)
        @host=args[:host]
        @port=args[:port]
        @requests=args[:requests]
        @responses=args[:responses]
        @protocol=args[:protocol]
        @server=nil
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
            tuple=@responses.pop
            write_response(tuple)
          end
        end
      end

      def write_response(tuple)
        socket=tuple.socket_struct.socket
        tuple.socket_struct.finished
        @protocol.write(socket: socket, data: tuple.data, close: tuple.socket_struct.close?)
      end

      def read_requests(socket)
        requests=@protocol.read socket: socket
        log.info "Fetched requests: #{requests}"
        requests
      end

      def start_server
        begin
          @server=TCPServer.new(@host,@port)
          log.info "Server started on #{@host}:#{@port}"
        rescue Exception => e
          log.error "Class #{self.class} was unable to start server on #{@host}:#{@port}. Error: #{e.message}"
        end
      end

      def defaults
        {host: "localhost", port: 9000, protocol: Protocol.new}
      end


    end
  end
end


