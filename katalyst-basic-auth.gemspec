# frozen_string_literal: true

require_relative "lib/katalyst/basic/auth/version"

Gem::Specification.new do |spec|
  spec.name          = "katalyst-basic-auth"
  spec.version       = Katalyst::Basic::Auth::VERSION
  spec.authors       = ["Katalyst Interactive"]
  spec.email         = ["admin@katalyst.com.au"]

  spec.summary       = "Gem to add basic auth on staging websites"
  # spec.description   = "Gem to add basic auth on staging websites"
  spec.homepage      = "https://github.com/katalyst/katalyst-basic-auth"
  spec.license       = "MIT"
  # Supports Rails 3+
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.8")

  spec.metadata["allowed_push_host"] = "https://github.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/katalyst/katalyst-basic-auth"
  spec.metadata["changelog_uri"] = "https://github.com/katalyst/katalyst-basic-auth/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
