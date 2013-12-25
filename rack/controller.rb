require 'erb'
require_relative "models/token"

class Controller
  def call(env)
    @token=Token.first
    @redirect_uri=ENV['VK_APP_URI']
    @id=ENV['VK_APP_ID']
    @secret=ENV['VK_APP_SECRET']
    Rack::Response.new(render("index.html.erb"))  
  end  
  def render(template)    
    path = File.expand_path("../views/#{template}", __FILE__)    
    ERB.new(File.read(path)).result(binding)  
  end
end
