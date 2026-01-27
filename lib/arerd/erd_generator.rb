# frozen_string_literal: true

require "erb"

module Arerd
  class ErdGenerator
    MERMAID_TEMPLATE_PATH = File.expand_path("./templates/erd.mmd.erb", __dir__)
    MARKDOWN_TEMPLATE_PATH = File.expand_path("./templates/erd.md.erb", __dir__)

    def self.generate_markdown(models:, associations:)
      mermaid = generate_mermaid(models:, associations:)

      template = File.read(MARKDOWN_TEMPLATE_PATH)
      ERB.new(template, trim_mode: "-").result_with_hash(mermaid:)
    end

    def self.generate_mermaid(models:, associations:)
      # Filter out STI child classes to avoid duplicate table definitions
      filtered_models = models.reject { |model| model.base_class != model }

      # Filter associations to only include those between filtered models
      # This removes associations referencing STI child classes
      filtered_associations = associations.select { |association|
        filtered_models.include?(association.left_model) &&
          filtered_models.include?(association.right_model)
      }

      template = File.read(MERMAID_TEMPLATE_PATH)
      ERB.new(template, trim_mode: "-").result_with_hash(models: filtered_models, associations: filtered_associations)
    end

    def self.collect_models_and_associations
      Rails.application.eager_load!

      models = ApplicationRecord.descendants
        .reject { |model| model.base_class != model } # Filter out STI child classes
        .sort_by(&:name)

      associations = Arerd::Association
        .build_associations_from_models(models)
        .sort

      {models:, associations:}
    end
  end
end
