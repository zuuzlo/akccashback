worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 180
preload_app true

before_fork do |server, worker|
  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
end