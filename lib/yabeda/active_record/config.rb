# frozen_string_literal: true

require "anyway"

module Yabeda
  module ActiveRecord
    # yabeda-activerecord configuration
    class Config < ::Anyway::Config
      config_name :yabeda_activerecord

      attr_config :buckets
    end
  end
end
