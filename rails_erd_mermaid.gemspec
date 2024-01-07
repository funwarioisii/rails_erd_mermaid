# frozen_string_literal: true

require_relative "lib/rails_erd_mermaid/version"

Gem::Specification.new do |spec|
  spec.name = "rails_erd_mermaid"
  spec.version = RailsErdMermaid::VERSION
  spec.authors = ["funwarioisii"]
  spec.email = ["kazuyukihashimoto2006@gmail.com"]

  spec.summary = "Generate Mermaid ERD for Rails"
  spec.description = "Generate Mermaid ERD for Rails"
  spec.homepage = "https://github.com/funwarioisii/rails_erd_mermaid"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/funwarioisii/rails_erd_mermaid"
  spec.metadata["changelog_uri"] = "https://github.com/funwarioisii/rails_erd_mermaid"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables << "erd-mermaid"
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "thor", ">= 1.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
