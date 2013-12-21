require 'rest_client'
require 'ostruct'

module Vk
  module IO
    class Web
      attr_accessor :frequency

      def initialize(args={})
        @requests=[]
        @responses=[]
        @last_request_time=Time.now
        args=defaults.merge args
        @frequency=args[:frequency]
        @thread=nil
        ObjectSpace.define_finalizer(self, proc {stop})
        start
      end

      def start
        @thread=Thread.new do
          while true do
            process_request
          end
        end
      end

      def stop
        Thread.kill(@thread) if @thread
      end

      def push(args)
        log "Incoming requests: #{args}"
        @requests << OpenStruct.new(request: args[:request], respond_to: args[:respond_to], priority: args[:prioirity]||0)
      end

      private

      def process_request
        return unless request=fetch_request
        delay
        response=send_request(request.request)
        begin
        request.respond_to.handle_response(response)
        rescue Exception => e
          log e.message
        end
      end 

      def fetch_request
        return nil if @requests.length==0
        priority=@requests.map(&:priority).max
        candidates=@requests.select {|x| x.priority==priority}
        request=candidates.shift
        @requests.delete request
        log "Fetched request for web processing: #{request}"
        request
      end

      def send_request(request)
        log "Fetching response from web..."
        response=RestClient.get(request)
        log "Fetched response from web: #{response[0..20]}..."
        response
      end

      def delay
        time_since_last_request=Time.now-@last_request_time # in seconds
        pause=[(@frequency-time_since_last_request).round(2), 0].max
        log "Slept #{pause} sec"
        sleep(pause) unless pause==0
        @last_request_time=Time.now
      end

      def defaults
        {frequency: 0.2}
      end

      def log(data)
        t=Time.now
        ms=(t.to_f*1000).to_i % 1000
        puts "#{t} #{ms}ms - #{data}"
      end


    end
  end  
end
