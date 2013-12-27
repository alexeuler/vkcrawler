require 'benchmark'
Benchmark.bm do |x|
  x.report("users.get") { 20.times {Vk::Api.users_get}}
end
