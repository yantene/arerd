require "test_helper"

require "minitest/autorun"

describe Arerd::ErdGenerator do
  describe ".generate_markdown" do
    it "starts with '```mermaid'" do
      associations = Arerd::Association.build_associations_from_models(MODELS)
      markdown = Arerd::ErdGenerator.generate_markdown(models: MODELS, associations: associations)

      assert markdown.start_with?("```mermaid"), "Markdown should start with ```mermaid"
    end

    it "ends with '```'" do
      associations = Arerd::Association.build_associations_from_models(MODELS)
      markdown = Arerd::ErdGenerator.generate_markdown(models: MODELS, associations: associations)

      assert markdown.rstrip.end_with?("```"), "Markdown should end with triple backticks"
    end

    it "contains Japanese translations when locale is set to ja" do
      original_locale = I18n.locale
      I18n.locale = :ja

      begin
        associations = Arerd::Association.build_associations_from_models(MODELS)
        markdown = Arerd::ErdGenerator.generate_markdown(models: MODELS, associations: associations)

        assert_includes markdown, "ユーザー", "Should contain Japanese translation for User model"
        assert_includes markdown, "投稿", "Should contain Japanese translation for Post model"
        assert_includes markdown, "名前", "Should contain Japanese translation for name attribute"
        assert_includes markdown, "タイトル", "Should contain Japanese translation for title attribute"
      ensure
        I18n.locale = original_locale
      end
    end
  end

  describe ".generate_mermaid" do
    it "starts with 'erDiagram'" do
      associations = Arerd::Association.build_associations_from_models(MODELS)
      mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS, associations: associations)

      assert mermaid.start_with?("erDiagram"), "Mermaid output should start with 'erDiagram'"
    end

    it "contains Japanese model names when locale is set to ja" do
      original_locale = I18n.locale
      I18n.locale = :ja

      begin
        associations = Arerd::Association.build_associations_from_models(MODELS)
        mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS, associations: associations)

        assert_includes mermaid, "User[\"User (ユーザー)\"]", "Should contain Japanese translation in entity definition"
        assert_includes mermaid, "Post[\"Post (投稿)\"]", "Should contain Japanese translation for Post entity"
        assert_includes mermaid, "Profile[\"Profile (プロフィール)\"]", "Should contain Japanese translation for Profile entity"
      ensure
        I18n.locale = original_locale
      end
    end

    it "contains Japanese attribute names when locale is set to ja" do
      original_locale = I18n.locale
      I18n.locale = :ja

      begin
        associations = Arerd::Association.build_associations_from_models(MODELS)
        mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS, associations: associations)

        assert_includes mermaid, "string name", "Should contain name attribute"
        assert_includes mermaid, "\"名前", "Should contain Japanese translation for name attribute"
        assert_includes mermaid, "string title", "Should contain title attribute"
        assert_includes mermaid, "\"タイトル\"", "Should contain Japanese translation for title attribute"
      ensure
        I18n.locale = original_locale
      end
    end

    it "falls back to English when Japanese translation is not available" do
      original_locale = I18n.locale
      I18n.locale = :ja

      begin
        associations = Arerd::Association.build_associations_from_models(MODELS)
        mermaid = Arerd::ErdGenerator.generate_mermaid(models: MODELS, associations: associations)

        assert_includes mermaid, "Tag[\"Tag (タグ)\"]", "Should contain Japanese translation for Tag entity"
      ensure
        I18n.locale = original_locale
      end
    end
  end
end
