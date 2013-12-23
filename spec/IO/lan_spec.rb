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
        end

        it "Reads from response queue and writes to localhost:9000. After all resonses in the same socket are wrote it closes the socket" do
          s=TCPSocket.new "localhost", 9000
          responses=@lan.instance_variable_get(:@responses)
          t1=Tuple.new(data:"Response1", socket: s, count: 2)
          t2=Tuple.new(data:"Response2", socket: s, count: 2)
          responses.push(t1)
          responses.push(t2)
          s.gets.chomp.should=="Response1"
          s.gets.chomp.should=="Response2"
          s.gets.should==nil
        end


      end
    end
  end
end
