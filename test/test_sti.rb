require "test_helper"

require "minitest/autorun"

describe "STI (Single Table Inheritance) Support" do
  describe "Arerd::ErdGenerator with STI models" do
    it "should not duplicate table definitions for STI child classes" do
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)
      mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS_WITH_STI, associations: associations)

      # Count how many times "animals" table appears in the diagram
      # STI child classes (Dog, Cat) should not create duplicate table definitions
      animal_definitions = mermaid.scan("Animal[").count
      dog_definitions = mermaid.scan("Dog[").count
      cat_definitions = mermaid.scan("Cat[").count

      # Only the parent class (Animal) should appear in the diagram
      expect(animal_definitions).must_equal 1, "Animal entity should appear exactly once"
      expect(dog_definitions).must_equal 0, "Dog (STI child) should not appear as a separate entity"
      expect(cat_definitions).must_equal 0, "Cat (STI child) should not appear as a separate entity"
    end

    it "should include the type column in STI parent class" do
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)
      mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS_WITH_STI, associations: associations)

      # The Animal entity should include the 'type' column
      assert_includes mermaid, "string type", "Animal entity should include the 'type' column for STI"
    end

    it "should filter out STI child classes from models list" do
      # When collecting models, STI child classes should be excluded
      # to avoid duplicate table definitions
      filtered_models = MODELS_WITH_STI.reject { |model| model.base_class != model }

      expect(filtered_models).must_include Animal
      expect(filtered_models).wont_include Dog
      expect(filtered_models).wont_include Cat
    end
  end

  describe "Arerd::Association with STI models" do
    it "should handle associations to STI parent class correctly" do
      # Even though Dog and Cat inherit from Animal, associations should
      # reference the parent table (animals)
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)

      # Should not have associations for Dog or Cat as separate entities
      dog_associations = associations.select { |a|
        a.left_model.name == "Dog" || a.right_model.name == "Dog"
      }
      cat_associations = associations.select { |a|
        a.left_model.name == "Cat" || a.right_model.name == "Cat"
      }

      expect(dog_associations.empty?).must_equal true
      expect(cat_associations.empty?).must_equal true
    end
  end
end
