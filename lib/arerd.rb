# frozen_string_literal: true

require_relative "arerd/association"
require_relative "arerd/erd_generator"
require_relative "arerd/version"

module Arerd
  class Error < StandardError; end
end

require "arerd/railtie" if defined?(Rails::Railtie)
