source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "bcrypt"
gem "bootstrap"
gem "bootstrap4-kaminari-views"
gem "cancancan", "~> 2.0"
gem "carrierwave"
gem "chatwork"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "devise"
gem "faker"
gem "figaro"
gem "font-awesome-rails"
gem "friendly_id", "~> 5.2.0"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "kaminari"
gem "mini_magick"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "paranoia", "~> 2.2"
gem "public_activity"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.6"
gem "rails-i18n"
gem "ransack"
gem "redis"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "social-share-button"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "mysql2"
  gem "rubocop", "~> 0.54.0", require: false
  gem "selenium-webdriver"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :production do
  gem "pg", "0.21.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
