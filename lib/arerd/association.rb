# frozen_string_literal: true

module Arerd
  class Association
    attr_reader :left_model, :left_key, :left_association_name,
      :right_model, :right_key, :right_association_name,
      :left_side_multiplicity, :right_side_multiplicity

    def initialize(
      left_model:,
      left_key:,
      left_association_name:,
      right_model:,
      right_key:,
      right_association_name:,
      left_side_multiplicity:,
      right_side_multiplicity:
    )
      @left_model = left_model
      @left_key = left_key
      @left_association_name = left_association_name
      @right_model = right_model
      @right_key = right_key
      @right_association_name = right_association_name
      @left_side_multiplicity = left_side_multiplicity
      @right_side_multiplicity = right_side_multiplicity
    end

    def self.build(association)
      case association.macro
      when :has_many
        return if association.options[:through]

        if association.inverse_of.nil?
          warn "Association #{association.name} has no inverse association. Skipping association."

          return
        end

        new(
          left_model: association.active_record,
          left_key: association.active_record_primary_key,
          left_association_name: association.name,
          right_model: association.class_name.constantize,
          right_key: association.foreign_key,
          right_association_name: association.inverse_of.name,
          left_side_multiplicity: association.inverse_of.options[:optional] ? :optional_one : :one,
          right_side_multiplicity: :optional_many
        )
      when :has_one
        return if association.options[:through]

        if association.inverse_of.nil?
          warn "Association #{association.name} has no inverse association. Skipping association."

          return
        end

        new(
          left_model: association.active_record,
          left_key: association.active_record_primary_key,
          left_association_name: association.name,
          right_model: association.class_name.constantize,
          right_key: association.foreign_key,
          right_association_name: association.inverse_of.name,
          left_side_multiplicity: association.inverse_of.options[:optional] ? :optional_one : :one,
          right_side_multiplicity: :optional_one
        )
      when :has_and_belongs_to_many
        if association.inverse_of.nil?
          warn "Association #{association.name} has no inverse association. Skipping association."

          return
        end

        return if association.active_record.name > association.class_name # Avoid duplicate associations

        new(
          left_model: association.active_record,
          left_key: association.active_record_primary_key,
          left_association_name: association.name,
          right_model: association.class_name.constantize,
          right_key: association.foreign_key,
          right_association_name: association.inverse_of.name,
          left_side_multiplicity: :optional_many,
          right_side_multiplicity: :optional_many
        )
      when :belongs_to
        if association.options[:polymorphic]
          warn "Polymorphic associations are not supported yet. Skipping association #{association.name}."

          return
        end

        if association.inverse_of.nil?
          warn "Association #{association.name} has no inverse association."
        end
      else
        warn "Unknown association type: #{association.macro} for #{association.name} in #{left_model.name}"
      end
    end

    def self.build_associations_from_models(models)
      models.flat_map(&:reflect_on_all_associations).map { |association|
        build(association)
      }.compact
    end
  end
end
