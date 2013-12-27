require "active_record"
require "vk/api"

module Vk
  class Api
    describe "Vk::Api" do

      it "Replaces _ with . and converting hash of arguments to request params when called method missing" do
        api=Api.new
        Token.stub_chain(:first, :token).and_return("123")
        api.should_receive(:send).with(IO::Protocol.code "https://api.vk.com/method/users.get?access_token=123&uid=whatever&v=0.5").and_return("success")
        response=api.users_get uid: "whatever", v: 0.5
        response.should=="success"
      end

      it "Can batch requests and send them at once" do
        api=Api.new
        Token.stub_chain(:first, :token).and_return("123")
        api.should_receive(:send).with(IO::Protocol.code ["https://api.vk.com/method/users.get?access_token=123&uid=whatever&v=0.5","https://api.vk.com/method/friends.get?access_token=123"]).and_return("success")
        response=api.batch do
          api.users_get uid: "whatever", v: 0.5
          api.friends_get
        end
        response.should=="success"
      end

      
    end
    
  end
end
