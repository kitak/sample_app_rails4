worker_processes 4

working_directory "/var/www/rails/sample_app/current"

listen "/var/www/rails/sample_app/current/run/unicorn.sock", :backlog => 64
pid "/var/www/rails/sample_app/current/pids/unicorn.pid"
listen 8080, :tcp_nopush => true

timeout 30

stderr_path "/var/www/rails/sample_app/current/log/unicorn.stderr.log"
stdout_path "/var/www/rails/sample_app/current/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

after_fork do |server, worker|
  #
  # Added the following code for Dalli
  #
  if defined?(ActiveSupport::Cache::DalliStore) && Rails.cache.is_a?(ActiveSupport::Cache::DalliStore)
    # Reset Rails's object cache
    # Only works with DalliStore
    Rails.cache.reset

    # Reset Rails's session store
    # If you know a cleaner way to find the session store instance, please let me know
    ObjectSpace.each_object(ActionDispatch::Session::DalliStore) { |obj| obj.reset }
  end 
  #
  # End of modifications for Dalli
  #
end
