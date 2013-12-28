require "vk/IO/protocol"
require "thread"
module Vk
  module IO
    describe "VK::IO::Protocol" do

      before :each do
        @str="Line1\nLine2\n#{Protocol::EOF}\nRequest2\n#{Protocol::EOF}\n"
        @arr=["Line1\nLine2", "Request2"]
        @protocol=Protocol.new
      end

      it "Codes array of data or a single data string into a set of strings separated by /n andEOF" do
        @protocol.code(@arr).should==@str
      end

      it "Decodes a string into array based on EOF" do
        @protocol.decode(@str).should==@arr
      end

    end
  end
end
