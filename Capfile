#load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
#load 'config/deploy' # remove this line to skip loading any of the default tasks

set :user, 'app'

role :vm, "app001.kitak.pb"

task :show_ls, :roles => [:vm] do
  run 'ls -la ~/.ssh'
end
