require "socket"
require_relative "token"
require_relative "IO/protocol"
require 'json'

module Vk
  class Api

    attr_reader :token
    EOF='xHvh58vuUU'

    def initialize
      @batch=false
      @batch_request=""
    end

    def method_missing(method, *args, &block)
      request=IO::Protocol.code form_request(method.to_s, *args, &block)
      @batch ? @batch_request << request : send(request)
    end

    def batch
      return unless block_given? 
      @batch=true
      yield
      response=send @batch_request
      @batch=false
      @batch_request=""
      response
    end

    def send(request)
      begin
        s=TCPSocket.new "localhost", 9000
      rescue Exception => e
        puts "Unable to connect to Vk IO daemon. #{e.message}"
        return
      end
      s.puts request
      s.close_write

      response=""
      while line=s.gets
        response << line
      end
      s.close
      responses=IO::Protocol. decode response
      responses.map {|x| JSON.parse x.force_encoding("UTF-8") }
    end

    private

    def form_request(method, *args, &block)
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
