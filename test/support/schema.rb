# frozen_string_literal: true

require "active_record"

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name, null: false, index: {unique: true}
    t.timestamps
  end

  create_table :posts do |t|
    t.string :title, null: false, default: ""
    t.text :body, null: false, default: ""
    t.references :user, null: false, foreign_key: true
    t.timestamps
  end

  create_table :tags do |t|
    t.string :name, null: false
    t.references :taggable, polymorphic: true, null: false
    t.timestamps
  end

  create_table :profiles do |t|
    t.references :user, null: false, foreign_key: true
    t.string :bio
    t.timestamps
  end

  create_table :avatars do |t|
    t.references :profile, foreign_key: true
    t.string :image_url
    t.timestamps
  end

  create_table :follows do |t|
    t.references :follower, null: false, foreign_key: {to_table: :users}
    t.references :followed, null: false, foreign_key: {to_table: :users}
    t.timestamps
  end
  add_index :follows, [:follower_id, :followed_id], unique: true

  create_table :notifications do |t|
    t.references :user, null: false, foreign_key: true
    t.references :sender, foreign_key: {to_table: :users}, null: true
    t.string :message, null: false, default: ""
    t.timestamps
  end

  create_table :communities do |t|
    t.string :name, null: false
    t.timestamps
  end

  create_join_table :communities, :users do |t|
    t.index :community_id
    t.index :user_id
    t.index [:community_id, :user_id], unique: true
  end
end
