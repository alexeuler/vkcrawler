require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2', # or 'postgresql' or 'sqlite3'
  host:     'localhost',
  database: 'vk_crawler',
  username: 'root',
  password: ENV['MY_SQL_PASS']
)
