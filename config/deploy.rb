# This include make constants like Rails.application accessible in files.
require File.expand_path('./environment', __dir__)

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.1'

set :application, 'askme'
set :repo_url, 'git@github.com:8uben/askme.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'main'

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, Rails.application.credentials.dig(:cap, :deploy_directory)


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# If you want to restart using `touch tmp/restart.txt`, add this to your config/deploy.rb:
set :passenger_restart_with_touch, true

# config for webpacker
set :assets_roles, %i[webpack] # Give the webpack role to a single server
set :assets_prefix, 'packs' # Assets are located in /packs/
set :keep_assets, 10 # Automatically remove stale assets
set :assets_manifests, lambda { # Tell Capistrano-Rails how to find the Webpacker manifests
  [release_path.join('public', fetch(:assets_prefix), 'manifest.json*')]
}
