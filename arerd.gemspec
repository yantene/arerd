# frozen_string_literal: true

require_relative "lib/arerd/version"

Gem::Specification.new do |spec|
  spec.name = "arerd"
  spec.version = Arerd::VERSION
  spec.authors = ["Shuhei YOSHIDA"]
  spec.email = ["contact@yantene.net"]

  spec.summary = "A Rails gem for generating an ERD from ActiveRecord models in Mermaid format"
  spec.description = "Provides a Rake task that extracts entity-relationship information from ActiveRecord models and generates an ER diagram in Mermaid notation."
  spec.homepage = "https://github.com/yantene/arerd"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yantene/arerd"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"

  spec.add_development_dependency "sqlite3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
