require 'rest_client'

class VK
  module IO
    class Web
      attr_accessor :frequency

      Request=Struct.new(:request, :respond_to, :priority) do
        def initialize(args)
          @request=args[:request]
          @respond_to=args[:respond_to]
          @priority=args[:priority]
        end
      end

      def initialize(args={})
        @requests=[]
        @responses=[]
        @last_request_time=Time.now
        args=defaults.merge args
        @frequency=args[:frequency]
        @thread=nil
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
        Thread.kill(@thread)
      end

      def push(args)
        puts "Here"
        @requests << Request.new(request: args[:request], respond_to: args[:respond_to], priority: args[:prioirity]||0)
      end

      private

      def process_request
        puts "#{@requests.length}" if @requests.length>0
        return unless request=fetch_request

        delay
        response=send_request(request.request)
        process_response(response, request.respond_to)
      end 

      def fetch_request
        return nil if @requests.length==0
        priority=@requests.map(&:priority).max
        candidates=@requests.select {|x| x.priority==priority}
        request=candidates.shift
        @requests.delete request
        request
      end

      def send_request(request)
        RestClient.get(request)
      end

      def process_response(response, respond_to)
        respond_to.process_response(response)
      end

      def delay
        time_since_last_request=Time.now-@last_request_time # in seconds
        @last_request_time=Time.now
        pause=Math.max(@frequency-time_since_last_request, 0)
        sleep(pause) unless pause==0
      end

      def defaults
        {frequency: 0.2}
      end
    end
  end  
end
