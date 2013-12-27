require "vk/IO/protocol"
require "thread"
module Vk
  module IO
    class Protocol
      describe "VK::IO::Protocol" do

        before :each do
          @str="Line1\nLine2\n#{EOF}\nRequest2\n#{EOF}\n"
          @arr=["Line1\nLine2", "Request2"]
        end

        it "Codes array of data or a single data string into a set of strings separated by /n andEOF" do
          Protocol.code(@arr).should==@str
        end

        it "Decodes a string into array based on EOF" do
          Protocol.decode(@str).should==@arr
        end

      end
    end
  end
end
