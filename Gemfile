source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gemspec

gem "appraisal"
gem "rails", ">= 5.0.0"

group :development, :test do
  gem "sqlite3", platform: :mri
end

group :development do
  gem "onkcop", require: false
end

group :test do
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "shoulda-matchers"
end
