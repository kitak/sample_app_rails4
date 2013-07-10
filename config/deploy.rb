require 'bundler/capistrano'
require 'capistrano/ext/multistage'
load 'deploy/assets'

set :stages, ["production", "database", "asset"]
set :default_stage, "production"

namespace :puppet do
  namespace :apply do
    task :app do
      run "cd ~kitak/sample_app_puppet; sudo git pull origin master"
      apply_manifest("app")
    end

    task :db do
      run "cd ~kitak/sample_app_puppet; git pull origin master"
      apply_manifest("db")
    end

    task :proxy do
      run "cd ~kitak/sample_app_puppet; sudo git pull origin master"
      apply_manifest("proxy")
    end
  end
end

def apply_manifest(puppet_role)
  manifest_path = "/home/kitak/sample_app_puppet"
  run "sudo puppet apply --modulepath=#{manifest_path}/modules:#{manifest_path}/roles #{manifest_path}/manifests/#{puppet_role}.pp"
end

namespace :db do
  desc 'ダミーデータの生成' 
  task :populate , roles: :db, execept: {no_release: true} do
    run "cd #{current_path}; bundle exec rake db:populate RAILS_ENV=production"
  end

  desc 'リセット。注意！' 
  task :reset , roles: :db, execept: {no_release: true} do
    run "cd #{current_path}; bundle exec rake db:reset RAILS_ENV=production"
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
    logger.important 'Upgrading Unicorn...', 'Unicorn'
    run "sudo /etc/init.d/unicorn upgrade"
  end

  desc "Clear cache"
  task :clear_cache, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake cache:clear"
  end
end
