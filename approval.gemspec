$LOAD_PATH.push File.expand_path("lib", __dir__)
require "approval/version"

Gem::Specification.new do |s|
  s.name        = "approval"
  s.version     = Approval::VERSION
  s.authors     = ["Yoshiyuki Hirano"]
  s.email       = ["yhirano@me.com"]
  s.summary     = "Approval workflow for Rails"
  s.description = s.summary
  s.homepage    = "https://github.com/yhirano55/approval"
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.2.0"

  s.add_development_dependency "bundler", "~> 1.15"

  s.files         = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files    = Dir["spec/**/*"]
  s.require_paths = ["lib"]
end
