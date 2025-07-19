# frozen_string_literal: true

module Arerd
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "arerd/tasks/erd.rake"
    end
  end
end
