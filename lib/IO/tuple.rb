module Vk
  module IO
    class Tuple
      attr_reader :data, :socket, :counter
      def initialize(args={})
        @data=args[:data]
        @socket=args[:socket]
        @counter=args[:counter]
      end
    end
  end
end
