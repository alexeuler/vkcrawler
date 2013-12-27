require 'rest_client'

module Vk
  module IO
    class Web
      def initialize(args={})
        @responses=args[:responses]
        @requests=args[:requests]
        start
      end

      def start
        Thread.new do
          while true
            tuple=@requests.pop
            Thread.new(tuple) do |t|
              t.data=get(t.data)
              @responses.push t
            end
          end
        end
      end

      private

      def get(request)
        RestClient.get request
      end

    end
  end  
end
