require 'json'
class VK
  APP_ID=Rails.configuration.vk[:app_id]
  TOKEN=Rails.configuration.vk[:token]
  BASE_URL="https://api.vk.com/method"

  def self.method_missing(method, *args, &block)
    request=form_request(method, *args)
    response=send_request(request)
    JSON.parse response
  end

  private

  def self.send_request(request)
    socket=TCPSocket.new('localhost', 9000)
    begin
      socket.puts(request)
      res=""
      while line=socket.gets
        res << line
      end
    ensure
      socket.close
    end
    res
  end

  def self.form_request(method_name,options={})
    res="#{BASE_URL}/#{method_name}?access_token=#{TOKEN}"
    options.each_pair do |key, value|
      res+="&#{key}=#{value}"
    end
    res
  end

end
