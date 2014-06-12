# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'bay-projection'
set :repo_url, "git@github.com:sethdn/#{fetch(:application)}.git"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/var/www/#{fetch(:application)}"
# set :deploy_to, "/var/www/bay-projection"


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


# namespace :deploy do

#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       # execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end

# # I ended up just doing it manually and keeping the conf in etc/nginx/sites-available
#   # desc 'Link Nginx'
#   # task :nginx do
#   #   on roles(:app) do
#   #     execute :ln, '-nfs', "#{current_path}/config/nginx.conf", "/etc/nginx/sites-enabled/#{fetch(:application)}"
#   #   end
#   # end
#   # after :finished, :nginx 

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
# end


namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: {no_release: true}
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  task :setup_config do
    on roles(:app) do
      execute :sudo, "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute :sudo, "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      # run "mkdir -p #{shared_path}/config"
      # put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
      puts "Now edit the config files in #{shared_path}."
    end
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config do
    on roles(:app)
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
  before "deploy", "deploy:check_revision"
end


