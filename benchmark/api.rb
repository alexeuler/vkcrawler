require 'benchmark'
Benchmark.bm do |x|
  api=Vk::Api.new
  x.report("users.get") do
    a=api.batch do
      20.times {api.users_get11}
    end
    a.each {|x| puts "Error:#{x}" if x["error"]}
  end
end
