# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in yabeda-activerecord.gemspec
gemspec

yabeda_version = ENV.fetch("YABEDA_VERSION", "~> 0.11")

case yabeda_version
when "HEAD"
  gem "yabeda", git: "https://github.com/yabeda-rb/yabeda"
else
  yabeda_version = "~> #{yabeda_version}.0" if yabeda_version.match?(/^\d+\.\d+$/)
  gem "yabeda", yabeda_version
end

activerecord_version = ENV.fetch("ACTIVERECORD_VERSION", "~> 7.0")
case activerecord_version
when "HEAD"
  git "https://github.com/rails/rails.git" do
    gem "activerecord"
    gem "rails"
  end
else
  activerecord_version = "~> #{activerecord_version}.0" if activerecord_version.match?(/^\d+\.\d+$/)
  gem "activerecord", activerecord_version
end

gem "sqlite3"

gem "rake", "~> 13.0"

gem "rspec", "~> 3.0"

gem "rubocop", "~> 1.30"

gem "debug"

gem "anyway_config", ">= 1.3", "< 3.0"
