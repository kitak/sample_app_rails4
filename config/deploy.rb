require 'bundler/capistrano'
load 'deploy/assets'

set :default_environment, {
  'RBENV_ROOT' => "/usr/local/rbenv",
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :application, "sample_app"
set :repository,  "https://github.com/kitak/sample_app_rails4.git"
set :scm, :git
set :branch, "master"
set :deploy_to, "/var/www/rails/sample_app"
set :rails_env, "production"
set :use_sudo, false 

set :shared_children, %w(system log pids run)

role :web, "app001.kitak.pb"
role :app, "app001.kitak.pb"
role :db,  "app001.kitak.pb", :primary => true # This is where Rails migrations will run
#role :db,  "app001.kitak.pb" # Slave

set :user, 'app'
set :user_group, 'app'

set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb"

def remote_file_exists?(full_path)
  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip == 'true'
end

def process_exists?(pid_file)
  capture("ps -p `cat #{pid_file}`; true").strip.split("\n").size == 2
end

after "deploy:setup" do
  run <<-CMD
    mkdir -p "#{shared_path}/run"
  CMD
  run "bundle exec rake db:populate RAILS_ENV=production"
  start
end

namespace :deploy do
  desc 'Start Unicorn'
  task :start, roles: :app, except: {no_release: true} do
    if remote_file_exists? unicorn_pid
      if process_exists? unicorn_pid
        logger.important 'Unicorn is already running!', 'Unicorn'
        next
      else
        run "rm #{unicorn_pid}"
      end
    end

    logger.important 'Starting Unicorn...', 'Unicorn'
    run "cd #{current_path} && bundle exec unicorn -c #{unicorn_config} -E #{rails_env} -D"
  end

  desc 'Stop Unicorn'
  task :stop, :roles => :app, :except => {:no_release => true} do
    if remote_file_exists? unicorn_pid
      if process_exists? unicorn_pid
        logger.important 'Stopping Unicorn...', 'Unicorn'
        run "kill -s QUIT `cat #{unicorn_pid}`"
      else
        run "rm #{unicorn_pid}"
        logger.important 'Unicorn is not running.', 'Unicorn'
      end
    else
      logger.important 'No PIDs found. Check if unicorn is running.', 'Unicorn'
    end
  end

  desc 'Reload Unicorn'
  task :reload, :roles => :app, :except => {:no_release => true} do
    if remote_file_exists? unicorn_pid
      logger.important 'Reloading Unicorn...', 'Unicorn'
      run "kill -s HUP `cat #{unicorn_pid}`"
    else
      logger.important 'No PIDs found. Starting Unicorn...', 'Unicorn'
      run "cd #{current_path} && bundle exec unicorn -c #{unicorn_config} -E #{rails_env} -D"
    end
  end

  desc 'Restart Unicorn'
  task :restart, :roles => :app, :except => {:no_release => true} do
    stop
    start
  end
end

