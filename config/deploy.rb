set :application, "MyMobileVideo"

# Git Repository
set :repository,  "git@github.com:tailic/MyMobileVideo.git"
set :scm, :git
set :branch, "cloud"
set :deploy_via, :remote_cache

# Server
set :use_sudo, false
server "141.22.27.161", :app, :web, :db
set :deploy_to, "/var/www/mmv"
set :user, "webadmin"
ssh_options[:keys] = ["~/webadmin.key"]

# Start/Restart Tasks
namespace :deploy do
   task :start do 
     run "cd #{current_path} && rake RAILS_ENV=production"
   end
   task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
     run "cd #{current_path} &&  rake RAILS_ENV=production"
  end
end
