require "IO/lan"
class VK
  module IO
    describe "VK::IO::Lan" do
      it "processes requests on localhost:9000" do
        lan=Lan.new
        lan.stub(:process).and_return("TestResponse")
        socket=TCPSocket.new('localhost', 9000)
        requests=["TestRequest1", "TestRequest2"]
        socket.puts requests.join("\n")
        responses=""
        while line=socket.gets.chomp do
          responses << line
        end
        responses.should=="TestResponseTestResponse"
      end
      
    end
    
  end
end
