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

role :web, "app001.kitak.pb" #, "app002.kitak.pb"
role :app, "app001.kitak.pb"
role :db,  "app001.kitak.pb", :primary => true # This is where Rails migrations will run
#role :db,  "app001.kitak.pb"

set :user, 'app'
set :user_group, 'app'

set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb"

namespace :db do
  desc 'ダミーデータの生成' 
  task :populate , roles: :app, execept: {no_release: true} do
    run "cd #{current_path}; bundle exec rake db:populate RAILS_ENV=production"
  end
end

namespace :deploy do
  desc 'Start Unicorn'
  task :start, roles: :app, except: {no_release: true} do
    logger.important 'Starting Unicorn...', 'Unicorn'
    run "sudo /etc/init.d/unicorn start"
  end

  desc 'Stop Unicorn'
  task :stop, :roles => :app, :except => {:no_release => true} do
    logger.important 'Stopping Unicorn...', 'Unicorn'
    run "sudo /etc/init.d/unicorn stop"
  end

  desc 'Reload Unicorn'
  task :reload, :roles => :app, :except => {:no_release => true} do
    logger.important 'Reloading Unicorn...', 'Unicorn'
    run "sudo /etc/init.d/unicorn reload"
  end

  desc 'Upgrade Unicorn'
  task :upgrade, :roles => :app, :except => {:no_release => true} do
    logger.important 'Reloading Unicorn...', 'Unicorn'
    run "sudo /etc/init.d/unicorn reload"
  end

  desc "Clear cache"
  task :clear_cache do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake cache:clear"
  end
end

namespace :puppet do
  namespace :apply do
    task :app do
      apply_manifest("app")
      deploy.upgrade
    end

    task :db do
      apply_manifest("db")
      deploy.upgrade
    end
  end
end

def apply_manifest(puppet_role)
  manifest_path = "/home/app/sample_app"
  run "sudo puppet apply --modulepath=#{manifest_path}/modules:#{manifest_path}/roles #{manifest_path}/manifests/#{puppet_role}.pp"
end
