require "socket"
require_relative "token"
require 'json'

module Vk
  class Api

    class << self
      attr_reader :token
    end
    EOF='xHvh58vuUU'

    def self.method_missing(method, *args, &block)
      request=form_request(method.to_s, *args, &block)
      puts request
      send(request)
    end

    def self.send(request)
      s=TCPSocket.new "localhost", 9000
      s.puts "#{request}\n#{EOF}"
      s.close_write
      response=""
      while line=s.gets
        line.chomp!
        response << line unless line==EOF
      end
      s.close
      JSON.parse response.force_encoding("UTF-8")
    end

    private

    def self.form_request(method, *args, &block)
      method.gsub!("_",".")
      token=Token.first.token
      res="https://api.vk.com/method/#{method}?access_token=#{token}"
      args[0] && args[0].each_pair do |key, value|
        res+="&#{key}=#{value}"
      end
      res
    end

  end
end
