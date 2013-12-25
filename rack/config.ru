require 'rack'
require File.expand_path("../controller", __FILE__)

builder = Rack::Builder.new do
  use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'Lj,hjtenhj1'
  end
  run Controller.new
end

Rack::Handler::Mongrel.run builder, :Port => 9292
