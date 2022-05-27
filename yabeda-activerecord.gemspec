# frozen_string_literal: true

require_relative "lib/yabeda/active_record/version"

Gem::Specification.new do |spec|
  spec.name = "yabeda-activerecord"
  spec.version = Yabeda::ActiveRecord::VERSION
  spec.authors = ["Andrey Novikov"]
  spec.email = ["envek@envek.name"]

  spec.summary = "Yabeda plugin to collect ActiveRecord metrics: query performance, connection pool stats, etc."
  spec.description = <<~DESCRIPTION
    Yabeda plugin for easy collection of ActiveRecord metrics: query performance, connection pool stats, etc.
  DESCRIPTION
  spec.homepage = "https://github.com/yabeda-rb/yabeda-activerecord"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/yabeda-rb/yabeda-activerecord/blob/master/CHANGELOG.md"

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

  spec.add_dependency "activerecord", ">= 6.0"
  spec.add_dependency "yabeda", "~> 0.6"
end
