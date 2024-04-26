# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "katalyst-basic-auth"
  spec.version       = "0.5.0"
  spec.authors       = ["Katalyst Interactive"]
  spec.email         = ["developers@katalyst.com.au"]

  spec.summary       = "Gem to add basic auth on staging websites"
  spec.description   = "Makes it easy to add basic auth on staging and development apps."
  spec.homepage      = "https://github.com/katalyst/katalyst-basic-auth"
  spec.license       = "MIT"

  # Supports Rails 3+
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.8")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/katalyst/basic-auth"
  spec.metadata["changelog_uri"] = "https://github.com/katalyst/basic-auth/blob/main/CHANGELOG.md"

  spec.files = Dir["{lib}/**/*", "CHANGELOG.md", "LICENSE.txt", "README.md"]

  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack"
end
