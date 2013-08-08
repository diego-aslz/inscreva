require "bundler/capistrano"

set :application, "inscreva"
set :repository,  "https://github.com/nerde/inscreva.git"

set :scm, :git
# set :git_enable_submodules, 1

set :deploy_to, "/var/www/#{application}"
set :user, 'root'
set :use_sudo, false
set :normalize_asset_timestamps, false

## DEPLOY WHEN SERVER HAS RBENV ###
set :bundle_flags, "--deployment --quiet --binstubs"
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

role :web, "madeira"                          # Your HTTP server, Apache/etc
role :app, "madeira"                          # This may be the same as your `Web` server
role :db,  "madeira", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config/initializers"
    put File.read("config/database.yml.example"),
        "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
end
