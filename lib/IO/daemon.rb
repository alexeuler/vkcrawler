require 'daemons'
require_relative 'web'
require_relative 'lan'

Daemons.run_proc('vk_daemon', {
              dir_mode: :script,
              dir: 'daemon_data',
              backtrace: true,
              monitor: true,
              log_output: true
            }) do
  web=VK::IO::Web.new
  VK::IO::Lan.new(web: web)
  loop {}
end
