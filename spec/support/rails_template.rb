rails_major_version = Rails::VERSION::STRING[0].to_i

# Add our local pubsub_notifier to the load path
inject_into_file "config/environment.rb",
                 "\n$LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))}')\nrequire \"approval\"\n",
                 after: (rails_major_version >= 5) ? "require_relative 'application'" : "require File.expand_path('../application', __FILE__)"

run "rm Gemfile"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

# Install
generate :'approval:install'

# Generate ActiveRecord Models
generate :model, "User name:string"

generate :model, "Book name:string"
inject_into_file "app/models/book.rb", "  acts_as_approval_resource\n", before: "end"

run "rm -r spec"

rake "db:migrate"
