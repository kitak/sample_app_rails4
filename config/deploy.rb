require 'bundler/capistrano'
require 'capistrano/ext/multistage'
load 'deploy/assets'

set :stages, ["app", "db"]
set :default_stage, "app"

namespace :puppet do
  namespace :apply do
    task :app do
      apply_manifest("app")
    end

    task :db do
      apply_manifest("db")
    end
  end
end

def apply_manifest(puppet_role)
  manifest_path = "/home/kitak/sample_app_puppet"
  run "sudo puppet apply --modulepath=#{manifest_path}/modules:#{manifest_path}/roles #{manifest_path}/manifests/#{puppet_role}.pp"
end
