role :web, "db001.kitak.pb"
role :app, "db001.kitak.pb"
role :db,  "db001.kitak.pb", :primary => true # This is where Rails migrations will run
set :user, 'kitak'
set :user_group, 'paperboy'
