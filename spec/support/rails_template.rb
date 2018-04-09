run "rm Gemfile"
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

generate :"approval:install"
generate :model, "User name:string"
inject_into_file "app/models/user.rb", "  acts_as_approval_user\n", before: "end"
generate :model, "Book name:string"
inject_into_file "app/models/book.rb", "  acts_as_approval_resource\n", before: "end"
run "rm -rf spec"
rake "db:migrate"
