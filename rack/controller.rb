require 'erb'
require_relative "models/token"

class Controller
  def call(env)
    tokens=Token.all.map {|x| {token: x.token, time_left: x.created_at+x.expires-Time.now}}
    max=tokens.map {|x| x[:time_left]}.max
    @token=tokens.select {|x| x[:time_left]==max}[0][:token]
    Rack::Response.new(render("index.html.erb"))  
  end  
  def render(template)    
    path = File.expand_path("../views/#{template}", __FILE__)    
    ERB.new(File.read(path)).result(binding)  
  end
end
