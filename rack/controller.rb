require 'erb'
require 'rest_client'
require_relative "models/token"
require 'json'

class Controller
  def call(env)
    @token=Token.first
    @redirect_uri=ENV['VK_APP_URI']
    @id=ENV['VK_APP_ID']
    @secret=ENV['VK_APP_SECRET']

    request=Rack::Request.new(env)
    if code=request.GET["code"]
      resp=RestClient.get "https://api.vk.com/oauth/token?client_id=#{@id}&redirect_uri=#{@redirect_uri}&code=#{code}&client_secret=#{@secret}"
      data=JSON.parse resp
      if token=data["access_token"]
        Token.delete_all
        t=Token.new token: token, expires: Time.now+data["expires_in"]
        t.save
      end
      response=Rack::Response.new
      response.redirect("/")
      response.finish
    else
      response=Rack::Response.new(render("index.html.erb"))  
      response.finish
    end
    ActiveRecord::Base.clear_active_connections!
    response
  end  

  def render(template)    
    path = File.expand_path("../views/#{template}", __FILE__)    
    ERB.new(File.read(path)).result(binding)  
  end

end
