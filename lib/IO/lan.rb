require_relative "web"

class VK
  module IO
    class Lan

      def initialize(args)
        args=defaults.merge(args)
        @host=args[:host]
        @port=args[:port]
        @web=Web.new
        start
      end

      def start
        server=TCPSocket.new(@host,@port)
        loop {
          Thread.new(server.accept) do |client|
            begin
              request=client.gets
              response=process(request)
              client.puts response
            rescue Exception => e
              log.error "Error after connection acceptance: #{e.message}"
            ensure
              client.close
              Thread.exit
            end
          end
        }
      end

      def respond_to
        
      end

      private

      def process(request)
        
      end

      def defaluts
        {host: 'localhost', port: 9000}
      end

    end
  end
end
