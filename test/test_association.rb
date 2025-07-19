require "test_helper"

require "minitest/autorun"

describe Arerd::Association do
  describe ".build" do
    describe "has_one and belongs_to associations" do
      it "creates a :one - :optional_one association" do
        assoc = User.reflect_on_association(:profile)
        arerd_assoc = Arerd::Association.build(assoc)

        expect(arerd_assoc.left_model).must_equal User
        expect(arerd_assoc.right_model).must_equal Profile
        expect(arerd_assoc.left_association_name).must_equal :profile
        expect(arerd_assoc.right_association_name).must_equal :user
        expect(arerd_assoc.left_side_multiplicity).must_equal :one
        expect(arerd_assoc.right_side_multiplicity).must_equal :optional_one
      end
    end

    describe "has_one and belongs_to (optional) associations" do
      it "creates a :optional_one - :optional_one association" do
        assoc = Profile.reflect_on_association(:avatar)
        arerd_assoc = Arerd::Association.build(assoc)

        expect(arerd_assoc.left_model).must_equal Profile
        expect(arerd_assoc.right_model).must_equal Avatar
        expect(arerd_assoc.left_association_name).must_equal :avatar
        expect(arerd_assoc.right_association_name).must_equal :profile
        expect(arerd_assoc.left_side_multiplicity).must_equal :optional_one
        expect(arerd_assoc.right_side_multiplicity).must_equal :optional_one
      end
    end

    describe "has_many and belongs_to associations" do
      it "creates a :one - :optional_many association" do
        assoc = User.reflect_on_association(:posts)
        arerd_assoc = Arerd::Association.build(assoc)

        expect(arerd_assoc.left_model).must_equal User
        expect(arerd_assoc.right_model).must_equal Post
        expect(arerd_assoc.left_association_name).must_equal :posts
        expect(arerd_assoc.right_association_name).must_equal :user
        expect(arerd_assoc.left_side_multiplicity).must_equal :one
        expect(arerd_assoc.right_side_multiplicity).must_equal :optional_many
      end
    end

    describe "has_many and belongs_to (optional) associations" do
      it "creates a :optional_one - :optional_many association" do
        assoc = User.reflect_on_association(:sent_notifications)
        arerd_assoc = Arerd::Association.build(assoc)

        expect(arerd_assoc.left_model).must_equal User
        expect(arerd_assoc.right_model).must_equal Notification
        expect(arerd_assoc.left_association_name).must_equal :sent_notifications
        expect(arerd_assoc.right_association_name).must_equal :sender
        expect(arerd_assoc.left_side_multiplicity).must_equal :optional_one
        expect(arerd_assoc.right_side_multiplicity).must_equal :optional_many
      end
    end

    describe "has_and_belongs_to_many associations" do
      it "creates a :optional_many - :optional_many association" do
        assoc = Community.reflect_on_association(:users)
        arerd_assoc = Arerd::Association.build(assoc)

        expect(arerd_assoc.left_model).must_equal Community
        expect(arerd_assoc.right_model).must_equal User
        expect(arerd_assoc.left_association_name).must_equal :users
        expect(arerd_assoc.right_association_name).must_equal :communities
        expect(arerd_assoc.left_side_multiplicity).must_equal :optional_many
        expect(arerd_assoc.right_side_multiplicity).must_equal :optional_many
      end
    end

    describe "has_many and belongs_to (polymorphic) associations" do
      it "creates a :one - :optional_many association" do
        assoc = User.reflect_on_association(:tags)
        p assoc
        arerd_assoc = Arerd::Association.build(assoc)
        p arerd_assoc

        expect(arerd_assoc.left_model).must_equal User
        expect(arerd_assoc.right_model).must_equal Tag
        expect(arerd_assoc.left_association_name).must_equal :tags
        expect(arerd_assoc.right_association_name).must_equal :taggable
        expect(arerd_assoc.left_side_multiplicity).must_equal :one
        expect(arerd_assoc.right_side_multiplicity).must_equal :optional_many
      end
    end

    describe "has_many through associations" do
      it "does not create an association for has_many through" do
        assoc = User.reflect_on_association(:followees)
        arerd_assoc = Arerd::Association.build(assoc)

        expect(arerd_assoc).must_be_nil
      end
    end

    describe "has_one through associations" do
      it "does not create an association for has_one through" do
        assoc = User.reflect_on_association(:avatar)
        arerd_assoc = Arerd::Association.build(assoc)

        expect(arerd_assoc).must_be_nil
      end
    end
  end

  describe ".build_associations_from_models" do
    it "builds associations from all models" do
      associations = Arerd::Association.build_associations_from_models(MODELS)

      expect(associations.size).must_equal 10
    end
  end
end
