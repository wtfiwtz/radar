source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'activerecord-import'
gem 'coffee-rails', '>= 4.2'
gem 'jbuilder', '>= 2.5'
gem 'puma', '>= 3.7'
gem 'rails', '>= 6'
gem 'rubocop'
gem 'pg'
gem 'sass-rails', '>= 5.0'
gem 'slim-rails'
gem 'sqlite3'
gem 'turbolinks', '>= 5'
gem 'uglifier', '>= 1.3.0'
gem 'amazing_print'
gem 'mysql2'


# gem 'therubyracer', platforms: :ruby
# gem 'redis', '~> 3.0'
# gem 'bcrypt', '~> 3.1.7'
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '>= 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen', '>= 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '>= 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
