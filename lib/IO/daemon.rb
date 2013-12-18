require 'daemons'

Daemons.run(File.dirname(__FILE__)+"/server.rb", {
              app_name: 'vk_daemon',
              dir_mode: :script,
              dir: 'daemon_data',
              backtrace: true,
              monitor: true,
              log_output: true
            })
