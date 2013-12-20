require "IO/lan"
class VK
  module IO
    describe "VK::IO::Lan" do

      before :all do
        @web=Object.new #doubles doesn't work in before all
        def @web.push(args={})
          args[:respond_to].handle_response(args[:request]+"Response")
        end
        @lan=Lan.new(web: @web)
        Thread.abort_on_exception=true
      end

      before :each do
        @socket=TCPSocket.new('localhost', 9000)        
      end

      after :each do
        @socket.close        
      end

      it "processes requests on localhost:9000" do
        @socket.puts "TestRequest1\n#{EOF}"
        line=@socket.gets.chomp
        line.should=="TestRequest1Response"
      end

      it "can process a bunch of requests through one socket" do
        @socket.puts "TestRequest1\nTestRequest2\n#{EOF}"
        result=[]
        response=""
        while line=@socket.gets do
          line.chomp!
          if line==EOF 
            result << response 
            response="" 
          else 
            response << line
          end
        end
        result.should==["TestRequest1Response","TestRequest2Response"]
      end
      
    end
    
  end
end
