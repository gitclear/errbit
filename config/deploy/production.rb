set :stage, :app
set :rails_env, "production"

server 'errbit.gitclear.com', user: 'deployuser', roles: %w(app web), primary: true

# Wbh June 2020: taken from original file
# role :app, %w(deploy@example.com)
# role :web, %w(deploy@example.com)
# role :db,  %w(deploy@example.com)


