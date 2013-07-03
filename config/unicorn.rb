worker_processes 4

working_directory "/var/www/rails/sample_app/current"

listen "/var/www/rails/sample_app/run/unicorn.sock", :backlog => 64
pid "/var/www/rails/sample_app/pids/unicorn.pid"
listen 8080, :tcp_nopush => true

timeout 30

pid "/var/www/rails/sample_app/pids/unicorn.pid"

stderr_path "/var/www/rails/sample_app/log/unicorn.stderr.log"
stdout_path "/var/www/rails/sample_app/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
