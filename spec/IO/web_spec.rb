require "IO/web"
class VK
  module IO
    describe "VK::IO::Web" do

      class Requester
        @@count=0
        def self.count
          @@count
        end
        def handle_response(response)
          @@count+=1
        end
      end
      
      it "processes request with predefined frequency" do
        @web=Web.new(frequency: 0.2)
        @web.stub(:send_request).and_return("Response")
        @requesters=[]
        start=Time.now
        5.times do |i|
          @requesters << Requester.new
          @web.push(request: "Mock Request #{i}", respond_to:@requesters[i])
        end
        until Requester.count==5 do
        end
        finish=Time.now
        (finish-start).round(2).should>=1
      end
      
    end
  end
end
