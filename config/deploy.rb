require "bundler/capistrano"

set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
ENV['INSCREVA_SHARED'] ||= shared_path
require "whenever/capistrano"

production = (ENV['STAGE'] == 'production')

set :application, "inscreva"
set :repository,  "https://github.com/nerde/inscreva.git"

set :scm, :git
# set :git_enable_submodules, 1

set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :normalize_asset_timestamps, false

set :bundle_flags, "--deployment --quiet"
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

if production
  role :web,       "realserver"
  role :app,       "realserver"
  role :db,        "realserver", :primary => true
  set :user,       'root'
else
  role :web,       "localhost:2222"
  role :app,       "localhost:2222"
  role :db,        "localhost:2222", :primary => true
  set :user,       'vagrant'
end

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "deploy:restart_service"

namespace :deploy do
  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config/initializers #{shared_path}/uploads "\
      "#{shared_path}/public/files  #{shared_path}/public/downloads"
    put File.read("config/database.yml.example"),
        "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -nfs #{shared_path}/uploads #{release_path}/uploads"
    run "ln -nfs #{shared_path}/public/files #{release_path}/public/files"
    run "ln -nfs #{shared_path}/public/downloads #{release_path}/public/downloads"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Restart the service"
  task :restart_service, roles: :web do
    run "#{'sudo ' unless production}/etc/init.d/#{application} stop"
    sleep 1
    run "#{'sudo ' unless production}/etc/init.d/#{application} start"
  end
end
