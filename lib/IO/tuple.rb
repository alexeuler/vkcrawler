require 'ostruct'

module Vk
  module IO
    class Tuple
      attr_accessor :data, :socket_struct
      class SocketStruct
        attr_accessor :socket, :counter
        
        def initialize(args={})
          @socket=args[:socket]
          @counter=args[:counter]
          @mutex=Mutex.new
        end

        def finished
          @mutex.synchronize do
            @counter-=1
          end
        end

        def close?
          counter==0
        end
      end
      def initialize(args={})
        @data=args[:data]
        @socket_struct=args[:socket_struct]        
      end
    end
  end
end
