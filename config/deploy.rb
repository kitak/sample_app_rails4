set :application, "sample_app"
set :repository,  "https://github.com/kitak/sample_app_rails4.git"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/tmp/sample_app"
set :rails_env, "production"

role :web, "app001.kitak.pb"
role :app, "app001.kitak.pb"
role :db,  "app001.kitak.pb", :primary => true # This is where Rails migrations will run
role :db,  "app001.kitak.pb"

set :user, 'app'
task :show_ls, :roles => [:app] do
  run 'ls -la ~/.ssh'
end
