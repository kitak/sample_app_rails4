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

role :web, "app001.kitak.pb", "app002.kitak.pb"
role :app, "app001.kitak.pb", "app002.kitak.pb"
role :db,  "app001.kitak.pb", :primary => true # This is where Rails migrations will run
set :user, 'app'
set :user_group, 'app'
