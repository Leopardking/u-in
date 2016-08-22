# Application and server settings
set :application, "u-in"
set :user,        "ubuntu"
set :host,        "52.8.107.148"
set :domain,      '52.8.107.148'

# Git
set :scm,         :git
set :repository,  "git@github.com:Marcus3166/u-in-.git"
set :branch,      "staging"

# Deployment options (production)
set :deploy_to,   "/var/www/#{application}"
set :use_sudo,    false
set :rails_env,   'staging'
