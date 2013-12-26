require "vk/IO/web"
require "vk/IO/tuple"
require "thread"

module Vk
  module IO

    describe "Web" do
      
      it "Reads from requests queue, fetches the request and pushes to responses queue with predetermined frequency" do
        requests=Queue.new
        responses=Queue.new
        web=Web.new requests: requests, responses: responses, frequency: 0.2
        web.should_receive(:get).exactly(5).times.and_return("Response")
        
        start=Time.now
        5.times do |i|
          requests.push Tuple.new(data: "Requests#{i}")
        end
        5.times do |i|
          responses.pop.data.should=="Response"
        end
        run_time=Time.now - start
        run_time.round(2).should==1
        run_time.should>=1
      end
      
    end

  end
end
