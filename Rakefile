require_relative "config/init"

task :test do
  require "irb"
  require_relative "lib/api"
  ARGV.clear
  IRB.start
end

namespace :db do
  task :migrate do
    dir=File.expand_path(File.dirname(__FILE__))+"/migrations"
    ActiveRecord::Migration.migrate(dir)
  end
  
  task :migration, [:name] do |task, args|
    dir=File.expand_path(File.dirname(__FILE__))+"/migrations"
    file_name = "#{dir}/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{args.name}.rb" 
    file=File.new(file_name, "w")
    file.puts("class #{args.name.capitalize}Migration < ActiveRecord::Migration")
    file.puts("end")
    file.close
  end
end
