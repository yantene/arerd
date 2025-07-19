# frozen_string_literal: true

require "arerd/erd_generator"

namespace :db do
  desc "Output ERD as Mermaid to STDOUT"
  namespace :erd do
    task mermaid: :environment do
      models, associations = Arerd::ErdGenerator.collect_models_and_associations.values_at(:models, :associations)
      puts Arerd::ErdGenerator.generate_mermaid(models:, associations:)
    end

    task markdown: :environment do
      models, associations = Arerd::ErdGenerator.collect_models_and_associations.values_at(:models, :associations)
      puts Arerd::ErdGenerator.generate_markdown(models:, associations:)
    end
  end
end
