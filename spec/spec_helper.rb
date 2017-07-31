$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path("support", __dir__)

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
require "bundler/setup"

ENV["RAILS_ENV"] ||= "test"

require "rails"

ENV["RAILS"] = Rails.version
ENV["RAILS_ROOT"] = File.expand_path("../rails/rails-#{ENV["RAILS"]}", __FILE__)

# Create the test app if it doesn't exists
system "rake setup" unless File.exist?(ENV["RAILS_ROOT"])

# load test app
require ENV["RAILS_ROOT"] + "/config/environment.rb"

# load RSpec
require "rspec/rails"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:should, :expect]
  end

  config.order = :random
  config.use_transactional_fixtures = true
end

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "name#{n}" }
  end

  factory :book do
    sequence(:name) { |n| "name#{n}" }
  end

  factory :request, class: "Approval::Request" do
    association :request_user, factory: :user

    trait :pending do
      state { :pending }
    end

    trait :cancelled do
      state { :cancelled }
      requested_at { Time.current }
      cancelled_at { Time.current }
    end

    trait :approved do
      association :respond_user, factory: :user
      state { :approved }
      requested_at { Time.current }
      approved_at { Time.current }
    end

    trait :rejected do
      association :respond_user, factory: :user
      state { :rejected }
      requested_at { Time.current }
      rejected_at { Time.current }
    end
  end

  factory :comment, class: "Approval::Comment" do
    sequence(:content) { |n| "content#{n}" }
    request_id 1
  end

  factory :item, class: "Approval::Item" do
    request_id 1

    trait :create do
      event { "create" }
      resource_type { "Book" }
      params { { name: "created_name" } }
    end

    trait :update do
      after(:build) do |item|
        book = create(:book)
        item.resource_id = book.id
        item.params = { name: "updated_name" }
      end

      event { "update" }
      resource_type { "Book" }
    end

    trait :destroy do
      after(:build) do |item|
        book = create(:book)
        item.resource_id = book.id
      end

      event { "destroy" }
      resource_type { "Book" }
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
