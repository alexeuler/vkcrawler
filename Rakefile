
task :console do
  require_relative "config/init"
  require "irb"
  ARGV.clear
  dir=File.expand_path(File.dirname(__FILE__))
  system "cd #{dir}/lib/vk/IO && ruby daemon.rb restart && cd #{dir}"
  IRB.start
  system "cd #{dir}/lib/vk/IO && ruby daemon.rb stop && cd #{dir}"
end

task :benchmark, :file_name do |t, args|
  require_relative "config/init"
  dir=File.expand_path(File.dirname(__FILE__))
  system "cd #{dir}/lib/vk/IO && ruby daemon.rb restart && cd #{dir}"
  sleep(1)
  require "#{dir}/benchmark/#{args.file_name}"
  system "cd #{dir}/lib/vk/IO && ruby daemon.rb stop && cd #{dir}"
end

db_namespace=namespace :db do

  task :environment do
    require_relative "config/init"    
    ActiveRecord::Migrator.migrations_paths=File.expand_path(File.dirname(__FILE__))+"/migrations"
  end

  task :migrate => :environment do
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths)
    db_namespace['dump'].invoke
  end

  task :rollback => :environment do
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, 1)
    db_namespace['dump'].invoke
  end
  
    task :dump => :environment do
      require 'active_record/schema_dumper'
      filename = File.join(ActiveRecord::Migrator.migrations_paths, 'schema.rb')
      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
      db_namespace['dump'].reenable
    end

  task :migration, [:name]  => [:environment] do |task, args|
    dir=File.expand_path(File.dirname(__FILE__))+"/migrations"
    file_name = "#{dir}/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{args.name}.rb" 
    file=File.new(file_name, "w")
    file.puts("class #{args.name.split('_').each {|s| s.capitalize!}.join('')} < ActiveRecord::Migration")
    file.puts("end")
    file.close
  end
end
