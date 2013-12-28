require "vk/IO/lan"
require "thread"
module Vk
  module IO
    class Lan
      describe "Vk::IO::Lan" do

        before :all do
          @requests=Queue.new
          @responses=Queue.new
          @lan=Lan.new requests: @requests, responses: @responses, frequency: 0.2
          @protocol=Protocol.new
          Thread.abort_on_exception=true
        end

        it "Listens on localhost:9000 and pushes to request queue. Close_write finishes request transmission" do
          s=TCPSocket.new "localhost", 9000
          5.times do |i|
            @protocol.write socket: s, data: "Request#{i}", close: i==4
          end
          requests=@lan.instance_variable_get(:@requests)
          5.times do |i|
            requests.pop.data.should=="Request#{i}"
          end
          requests.length.should == 0
        end

        it "Reads from response queue and writes to localhost:9000." do
          s=TCPSocket.new "localhost", 9000
          @protocol.write socket: s, data: ["Request1", "Request2"]
          requests=@lan.instance_variable_get(:@requests)
          responses=@lan.instance_variable_get(:@responses)
          responses.push requests.pop
          responses.push requests.pop
          @protocol.read(socket: s).should==["Request1", "Request2"]
        end
      end
    end
  end
end
