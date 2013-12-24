require "IO/lan"
require "thread"
module Vk
  module IO
    class Lan
      describe "VK::IO::Lan" do

        before :all do
          @requests=Queue.new
          @responses=Queue.new
          @lan=Lan.new requests: @requests, responses: @responses
          Thread.abort_on_exception=true
        end

        it "Listens on localhost:9000 and pushes to request queue. Requests are separated by \\n and ends with EOF=#{EOF}" do
          s=TCPSocket.new "localhost", 9000
          s.puts "Request1\nRequest2\n#{EOF}"
          requests=@lan.instance_variable_get(:@requests)
          requests.pop.data.should=="Request1"
          requests.pop.data.should=="Request2"
          requests.length.should == 0
          s.close
        end

        it "Reads from response queue and writes to localhost:9000. " do
          s=TCPSocket.new "localhost", 9000
          s.puts "Request1\nRequest2\n#{EOF}"
          requests=@lan.instance_variable_get(:@requests)
          responses=@lan.instance_variable_get(:@responses)
          responses.push requests.pop
          responses.push requests.pop
          s.gets.should=="Request1\n"
          s.gets.should=="#{EOF}\n"
          s.gets.should=="Request2\n"
          s.gets.should=="#{EOF}\n"
          s.gets.should==nil
          s.close
        end
      end
    end
  end
end
