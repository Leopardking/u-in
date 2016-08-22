# Application and server settings
set :application, "u-in"
set :user,        "ubuntu"
set :host,        "54.67.33.54"
set :domain,      '54.67.33.54'

# Git
set :scm,         :git
set :repository,  "git@github.com:Marcus3166/u-in-.git"
set :branch,      "master"

# Deployment options (staging and production)
set :deploy_to,   "/var/www/#{application}"
set :use_sudo,    false
set :rails_env,   'production'