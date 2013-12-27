require 'benchmark'
Benchmark.bm do |x|
  api=Vk::Api.new
  x.report("users.get") do
    api.batch do
      20.times {api.users_get}
    end
  end
end
