# frozen_string_literal: true

require "yaml"

ENV["RAILS_ENV"] ||= "test"

database_yml_path = File.expand_path(File.join(File.dirname(__FILE__), "database.yml"))
database_yml = YAML.safe_load(ERB.new(File.read(database_yml_path)).result)
ActiveRecord::Base.configurations = database_yml

database_config =
  if ActiveRecord.version >= Gem::Version.new("6.1") # See https://github.com/rails/rails/pull/38256
    ActiveRecord::Base.configurations.configs_for(env_name: ENV["RAILS_ENV"]).map do |hc|
      [hc.name, hc.configuration_hash.stringify_keys]
    end.to_h
  else
    ActiveRecord::Base.configurations
  end

database_config.each do |_name, config|
  next unless config["adapter"] == "sqlite3"
  next if config["database"] == ":memory:" || !File.exist?(config["database"])

  File.unlink(config["database"])
end

File.unlink("tmp/activerecord.log") if File.exist?("tmp/activerecord.log")
log = Logger.new("tmp/activerecord.log")
log.sev_threshold = Logger::DEBUG
ActiveRecord::Base.logger = log

# setup primary database:
ActiveRecord::Base.establish_connection(database_config["primary"])
ActiveRecord::Schema.define(version: 0) do
  create_table :test_models do |t|
    t.string :name
  end
end
ActiveRecord::Base.connection.disconnect!

# setup another database:
ActiveRecord::Base.establish_connection(database_config["another"])
ActiveRecord::Schema.define(version: 0) do
  create_table :another_db_test_models do |t|
    t.string :name
  end
end
ActiveRecord::Base.connection.disconnect!

# Models
if ActiveRecord.version >= Gem::Version.new("6.1")
  class PrimaryApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    connects_to database: { writing: :primary, reading: :primary_replica }
  end

  class AnotherApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    connects_to database: { writing: :another }
  end

  class TestModel < PrimaryApplicationRecord; end
  class AnotherDbTestModel < AnotherApplicationRecord; end

else
  class TestModel < ActiveRecord::Base; end
  class AnotherDbTestModel < ActiveRecord::Base; end
end

TestModel.establish_connection(:primary)
AnotherDbTestModel.establish_connection(:another)
