# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :user, 'rails'
# set :deploy_user, 'rails'
server '167.172.104.183', port: 22, roles: [:web, :app, :db], primary: true

set :rbenv_type, :user # or :system, or :fullstaq (for Fullstaq Ruby), depends on your rbenv setup
set :rbenv_ruby, '3.0.3'
# set :chruby_ruby, 'ruby-3.0.2'

# in case you want to set ruby version from the file:
# set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_path, "~/.rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :branch, 'main'

set :passenger_restart_with_touch, true

set :application, "capistranotest"
set :repo_url, "git@github.com:thomaspietschmann/capistrano-test.git"
#
# set :puma_threads,    [4, 16]
# set :puma_workers,    0

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

#
#
# set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
# set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
# set :puma_access_log, "#{release_path}/log/puma.access.log"
# set :puma_error_log,  "#{release_path}/log/puma.error.log"
# set :puma_preload_app, true
# set :puma_worker_timeout, nil
# set :puma_init_active_record, true  # Change to false when not using ActiveRecord


append :linked_files, "config/master.key", ".env"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "public/uploads", "tmp/sockets"

namespace :setup do
  desc 'Copy env keys'
  task :copy_keys do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! "#{Dir.pwd}/config/master.key", "#{shared_path}/config/master.key"
      upload! "#{Dir.pwd}/.env", "#{shared_path}/.env"
    end
  end
end

#
# namespace :puma do
#   desc 'Create Directories for Puma Pids and Socket'
#   task :make_dirs do
#     on roles(:app) do
#       execute "mkdir #{shared_path}/tmp/sockets -p"
#       execute "mkdir #{shared_path}/tmp/pids -p"
#     end
#   end
#
#   before 'deploy:starting', 'puma:make_dirs'
# end
#
# namespace :deploy do
#   desc "Make sure local git is in sync with remote."
#   task :check_revision do
#     on roles(:app) do
#
#       # Update this to your branch name: master, main, etc. Here it's main
#       unless `git rev-parse HEAD` == `git rev-parse origin/main`
#         puts "WARNING: HEAD is not the same as origin/main"
#         puts "Run `git push` to sync changes."
#         exit
#       end
#     end
#   end

  # desc 'Initial Deploy'
  # task :initial do
  #   on roles(:app) do
  #     before 'deploy:restart', 'puma:start'
  #     invoke 'deploy'
  #   end
  # end
  #
  # desc 'Restart application'
  #   task :restart do
  #     on roles(:app), in: :sequence, wait: 5 do
  #       invoke 'puma:restart'
  #     end
  # end
  #
  # before :starting,     :check_revision
  # after  :finishing,    :compile_assets
  # after  :finishing,    :cleanup
  # after  :finishing,    :restart
# end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma