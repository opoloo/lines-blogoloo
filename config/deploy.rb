require 'bundler/capistrano'
#require "rvm/capistrano"

#set :rvm_type, :system

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "blogoloo"
set :user, 'kingpinky'
#set :domain, 'stampy.kunden.opoloo.de'
#set :port, 981
set :port, 981

set :repository,  "git@github.com:opoloo/blogoloo.git"
set :scm, :git
set :branch, 'master'
set :scm_verbose, true

role(:web) { domain }
role(:app) { domain }
role(:db) { domain }

#role :app, domain
#role :db,  domain, :primary => true

# deploy config
#set :deploy_to, applicationdir
set(:deploy_to) { "#{applicationdir}" }
set :deploy_via, :export
set(:git_shallow_clone) { false }

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
ssh_options[:forward_agent] = true
ssh_options[:keys] = %w(/home/kingpinky/.ssh/id_dsa)
set :use_sudo, true


# Passenger
namespace :deploy do

  namespace :assets do
    task :symlink, roles: :web do
      run ("rm -rf #{latest_release}/public/assets &&
            mkdir -p #{latest_release}/public &&
            mkdir -p #{shared_path}/assets &&
            ln -s #{shared_path}/assets #{latest_release}/public/assets")
    end
  end
  desc "Install bundled gems as root"
  task :bundle do
    run "cd #{release_path}; sudo bundle install"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end

  desc "copy and link database.yml"
  task :configure_database do
    run "mkdir -p #{shared_path}/config"
    run "cp #{release_path}/config/database.yml.dist #{shared_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before 'deploy:finalize_update', 'deploy:assets:symlink'
after 'deploy:finalize_update', 'deploy:configure_database'
after 'deploy:update_code', 'deploy:symlink_shared'
