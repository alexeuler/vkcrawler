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
  web=Vk::IO::Web.new
  Thread.new do
    Vk::IO::Lan.new(web: web)
  end
  Thread.stop
end
