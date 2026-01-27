require "test_helper"

require "minitest/autorun"

describe "STI (Single Table Inheritance) Support" do
  describe "Arerd::ErdGenerator with STI models" do
    it "should not duplicate table definitions for STI child classes" do
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)
      mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS_WITH_STI, associations: associations)

      # Count how many times "users" table appears in the diagram
      # STI child classes (AdminUser, RegularUser) should not create duplicate table definitions
      user_definitions = mermaid.scan("User[").count
      admin_user_definitions = mermaid.scan("AdminUser[").count
      regular_user_definitions = mermaid.scan("RegularUser[").count

      # Only the parent class (User) should appear in the diagram
      expect(user_definitions).must_equal 1, "User entity should appear exactly once"
      expect(admin_user_definitions).must_equal 0, "AdminUser (STI child) should not appear as a separate entity"
      expect(regular_user_definitions).must_equal 0, "RegularUser (STI child) should not appear as a separate entity"
    end

    it "should include the type column in STI parent class" do
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)
      mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS_WITH_STI, associations: associations)

      # The User entity should include the 'type' column for STI
      assert_includes mermaid, "string type", "User entity should include the 'type' column for STI"
    end

    it "should filter out STI child classes from models list" do
      # When collecting models, STI child classes should be excluded
      # to avoid duplicate table definitions
      filtered_models = MODELS_WITH_STI.reject { |model| model.base_class != model }

      expect(filtered_models).must_include User
      expect(filtered_models).wont_include AdminUser
      expect(filtered_models).wont_include RegularUser
    end

    it "should filter out associations referencing STI child classes" do
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)
      mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS_WITH_STI, associations: associations)

      # AuditLog entity should still appear (it's not a STI child)
      audit_log_definitions = mermaid.scan("AuditLog[").count
      expect(audit_log_definitions).must_equal 1, "AuditLog should appear in the diagram"

      # However, the association to AdminUser should be filtered out
      # because AdminUser is not in the diagram
      admin_user_audit_log_relation = mermaid.scan(/AdminUser.*AuditLog/).count
      expect(admin_user_audit_log_relation).must_equal 0, "Association to AdminUser should be filtered out"

      # AuditLog appears as an orphan entity (no associations shown)
      # This is expected behavior until Issue #10 is implemented
    end
  end

  describe "Arerd::Association with STI models" do
    it "should collect associations from STI child classes" do
      # AdminUser and RegularUser are STI children, but their associations
      # should still be collected (even though the models themselves are filtered from display)
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)

      # AdminUser has audit_logs association, so it should be in the collected associations
      admin_user_associations = associations.select { |a|
        a.left_model.name == "AdminUser" || a.right_model.name == "AdminUser"
      }

      # RegularUser has no additional associations beyond User
      regular_user_associations = associations.select { |a|
        a.left_model.name == "RegularUser" || a.right_model.name == "RegularUser"
      }

      # AdminUser should have audit_logs association
      expect(admin_user_associations.empty?).must_equal false
      # RegularUser has no unique associations
      expect(regular_user_associations.empty?).must_equal true
    end

    it "should filter associations in the diagram even if collected" do
      # AdminUser has audit_logs association, which is collected
      associations = Arerd::Association.build_associations_from_models(MODELS_WITH_STI)

      # Check if audit_logs association exists with AdminUser in collected associations
      admin_audit_log_associations = associations.select { |a|
        a.left_model.name == "AdminUser" && a.right_model.name == "AuditLog"
      }

      # The association is collected (because we build from all models including STI children)
      expect(admin_audit_log_associations.empty?).must_equal false

      # However, when generating the diagram, it should be filtered out
      mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS_WITH_STI, associations: associations)

      # AdminUser should not appear in relationships
      expect(mermaid.include?("AdminUser")).must_equal false

      # This demonstrates the fix: associations referencing filtered models
      # are also filtered from the diagram
    end
  end
end
