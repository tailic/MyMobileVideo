set :application, "MyMobileVideo"
set :repository,  "git@github.com:tailic/MyMobileVideo.git"
ssh_options[:forward_agent] = true
set :use_sudo, true

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :branch, "cloud"
set :deploy_via, :remote_cache

set :deploy_to, "/var/www/mmv"
set :user, "webadmin"
ssh_options[:keys] = ["webadmin.key"]
default_run_options[:pty] = true

server "141.22.27.161", :app, :web, :db


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

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
