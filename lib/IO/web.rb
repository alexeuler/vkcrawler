require 'rest_client'

module Vk
  module IO
    class Web
      def initialize(args={})
        args=defaults.merge(args)
        @responses=args[:responses]
        @requests=args[:requests]
        @frequency=args[:frequency]
        @last_fetch=Time.now
        start
      end

      def start
        Thread.new do
          while true
            tuple=@requests.pop
            delay
            tuple.data=get(tuple.data)
            @responses.push tuple
          end
        end
      end

      private

      def get(request)
        RestClient.get request
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

    end
  end  
end
