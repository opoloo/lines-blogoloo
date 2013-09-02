set :applicationdir, "/var/rails/blogoloo"
set :domain, 'blog.opoloo.de'

after "deploy", "refresh_sitemaps"
task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
end
