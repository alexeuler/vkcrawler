def require_dir(dir)
  Dir[File.dirname(__FILE__) + "/../#{dir}/*.rb"].each {|file| require file }
end

require_relative "active_record_init"
require_dir "lib/models"
require_dir "lib/vk"

