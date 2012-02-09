set :application, "hacks"
set :repository, "git@github.com:rewiredstate/hacks.git" 

set :scm, :git

set :deploy_to, "/data/vhosts/hacks.rewiredstate.org/deploy"

default_run_options[:pty] = true 

role :web, "brie.rewiredstate.org" 
role :app, "brie.rewiredstate.org" 
role :db,  "brie.rewiredstate.org", :primary => true 

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
    task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do
        run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end
end
