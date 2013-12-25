require 'daemons'
require 'thread'
require_relative 'web'
require_relative 'lan'

Daemons.run_proc('vk_daemon', {
              dir_mode: :script,
              dir: 'daemon_data',
              backtrace: true,
              monitor: true,
              log_output: true
            }) do
  requests=Queue.new
  responses=Queue.new
  web=Vk::IO::Web.new requests: requests, responses: responses
  lan=Vk::IO::Lan.new requests: requests, responses: responses
  sleep
end
