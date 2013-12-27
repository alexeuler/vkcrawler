require 'rest_client'
require_relative 'logger'

module Vk
  module IO
    class Web
      include Logger
      def initialize(args={})
        args=defaults.merge args
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
            Thread.new(tuple) do |t|
              t.data=get(t.data)
              @responses.push t
            end
          end
        end
      end

      private

      def get(request)
        log.info "Started request #{request}"
        RestClient.get request
      end

      def delay
        since_last_fetch=Time.now-@last_fetch # in seconds
        pause=[(@frequency-since_last_fetch).round(4), 0].max
        sleep(pause) unless pause==0
        @last_fetch=Time.now
      end

      def defaults
        {frequency: 1.0/3}
      end

    end
  end  
end
