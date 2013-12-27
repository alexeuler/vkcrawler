require "vk/IO/web"
require "vk/IO/tuple"
require "thread"

module Vk
  module IO

    describe "Web" do
      
      it "Reads from requests queue, fetches the request and pushes to responses queue" do
        requests=Queue.new
        responses=Queue.new
        web=Web.new requests: requests, responses: responses
        web.should_receive(:get).exactly(5).times.and_return("Response")
        5.times do |i|
          requests.push Tuple.new(data: "Requests#{i}")
        end
        5.times do |i|
          responses.pop.data.should=="Response"
        end
      end
      
    end

  end
end
