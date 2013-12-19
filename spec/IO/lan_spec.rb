require "IO/lan"
class VK
  module IO
    describe "VK::IO::Lan" do
      it "processes requests on localhost:9000" do
        web=double("Web")
        def web.push(args={})
          args[:respond_to].process_response("TestResponse")
        end
        lan=Lan.new(web: web)
        socket=TCPSocket.new('localhost', 9000)
        socket.puts "TestRequest1"
        line=socket.gets.chomp
        line.should=="TestResponse"
      end
      
    end
    
  end
end
