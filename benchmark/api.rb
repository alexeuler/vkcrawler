require 'benchmark'
Benchmark.bm do |x|
  api=Vk::Api.new
  x.report("users.get 20 times") do
    a=api.batch do
      20.times {api.users_get}
    end
    a.each {|x| puts "Error:#{x}" if x["error"]}
  end

  x.report("friends.get 20 times") do
    a=api.batch do
      20.times {api.friends_get}
    end
    a.each {|x| puts "Error:#{x}" if x["error"]}
  end


end
