# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "active_record"
require "arerd"
require "i18n"

require "minitest/autorun"

# Setup DB connection and schema for all tests
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
require_relative "support/schema"
require_relative "support/models"

# I18n設定
I18n.load_path += Dir[File.expand_path("support/locales/*.yml", __dir__)]
I18n.available_locales = [:en, :ja]
I18n.default_locale = :en
