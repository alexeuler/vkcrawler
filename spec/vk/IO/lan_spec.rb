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
            s.puts @protocol.code "Request#{i}"
          end
          s.close_write
          requests=@lan.instance_variable_get(:@requests)
          5.times do |i|
            requests.pop.data.should=="Request#{i}"
          end
          requests.length.should == 0
        end

        it "Reads from response queue and writes to localhost:9000." do
          s=TCPSocket.new "localhost", 9000
          s.puts @protocol.code ["Request1", "Request2"]
          s.close_write
          requests=@lan.instance_variable_get(:@requests)
          responses=@lan.instance_variable_get(:@responses)
          responses.push requests.pop
          responses.push requests.pop
          resp=""
          while line=s.gets
            resp << line
          end
          @protocol.decode(resp).should==["Request1", "Request2"]
          s.gets.should==nil
          s.close
        end
      end
    end
  end
end
