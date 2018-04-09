require "bundler"
require "rake"

Bundler.setup
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc "Creates a test rails app for the specs to run against"
task :setup do
  require "rails/version"
  system <<-COMMAND
    bundle exec rails new tmp/rails-#{Rails::VERSION::STRING} \
      -m spec/support/rails_template.rb \
      --skip-bundle \
      --skip-spring \
      --skip-listen \
      --skip-turbolinks \
      --skip-bootsnap \
      --skip-test \
      --skip-git \
      --skip-yarn \
      --skip-puma \
      --skip-action-mailer \
      --skip-action-cable
  COMMAND
end

namespace :tmp do
  task :clear do
    require "fileutils"
    FileUtils.rm_r("tmp")
  end
end
