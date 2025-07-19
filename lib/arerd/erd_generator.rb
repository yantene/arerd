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
      template = File.read(MERMAID_TEMPLATE_PATH)
      ERB.new(template, trim_mode: "-").result_with_hash(models:, associations:)
    end

    def self.collect_models_and_associations
      Rails.application.eager_load!

      models = ApplicationRecord.descendants

      associations = Arerd::Association.build_associations_from_models(models)

      {models:, associations:}
    end
  end
end
