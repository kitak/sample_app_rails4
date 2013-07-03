require 'bundler/capistrano'
require 'capistrano-rbenv'
load 'deploy/assets'

set :rbenv_ruby_version, '2.0.0-p195'

set :default_environment, {
  'RBENV_ROOT' => "/usr/local/rbenv",
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :application, "sample_app"
set :repository,  "https://github.com/kitak/sample_app_rails4.git"
set :scm, :git
set :branch, "master"
set :deploy_to, "/tmp/sample_app"
set :rails_env, "production"
set :use_sudo, false 

role :web, "app001.kitak.pb"
role :app, "app001.kitak.pb"
role :db,  "app001.kitak.pb", :primary => true # This is where Rails migrations will run
#role :db,  "app001.kitak.pb" # Slave

set :user, 'app'
set :user_group, 'app'

after "deploy:setup" do
  run <<-CMD
    mkdir -p "#{shared_path}/run"
  CMD
end

