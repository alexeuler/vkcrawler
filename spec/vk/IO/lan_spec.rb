require "vk/IO/lan"
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

        it "Listens on localhost:9000 and pushes to request queue. Requests are separated by EOF=#{EOF}. On finish call close_write." do
          s=TCPSocket.new "localhost", 9000
          s.puts "Request1"
          s.puts EOF
          s.puts "Request2"
          s.puts EOF
          s.close_write
          requests=@lan.instance_variable_get(:@requests)
          requests.pop.data.should=="Request1"
          requests.pop.data.should=="Request2"
          requests.length.should == 0
        end

        it "Reads from response queue and writes to localhost:9000. Respnoses are separated by EOF=#{EOF}." do
          s=TCPSocket.new "localhost", 9000
          s.puts "Request1"
          s.puts EOF
          s.puts "Request2"
          s.puts EOF
          s.close_write
          requests=@lan.instance_variable_get(:@requests)
          responses=@lan.instance_variable_get(:@responses)
          responses.push requests.pop
          responses.push requests.pop
          s.gets.chomp.should=="Request1"
          s.gets.chomp.should==EOF
          s.gets.chomp.should=="Request2"
          s.gets.chomp.should==EOF
          s.gets.should==nil
          s.close
        end
      end
    end
  end
end
