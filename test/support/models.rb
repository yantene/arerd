# frozen_string_literal: true

require "active_record"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class User < ApplicationRecord
  has_many :posts, inverse_of: :user
  has_one :profile, inverse_of: :user
  has_one :avatar, through: :profile, inverse_of: :user

  has_many :follows, foreign_key: :follower_id, inverse_of: :follower
  has_many :followees, through: :follows, source: :followee, inverse_of: :followers

  has_many :reverse_follows, class_name: "Follow", foreign_key: :followed_id, inverse_of: :followee
  has_many :followers, through: :reverse_follows, source: :follower, inverse_of: :followees

  has_many :notifications, inverse_of: :user
  has_many :sent_notifications, class_name: "Notification", foreign_key: :sender_id, inverse_of: :sender

  has_many :tags, as: :taggable, dependent: :destroy, inverse_of: :taggable

  has_and_belongs_to_many :communities, inverse_of: :users
end

class Post < ApplicationRecord
  belongs_to :user, inverse_of: :posts

  has_many :tags, as: :taggable, dependent: :destroy, inverse_of: :taggable
end

class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true, inverse_of: :tags
end

class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile

  has_one :avatar, inverse_of: :profile, dependent: :destroy
end

class Avatar < ApplicationRecord
  belongs_to :profile, optional: true, inverse_of: :avatar
  has_one :user, through: :profile, inverse_of: :avatar
end

class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", inverse_of: :follows
  belongs_to :followee, class_name: "User", inverse_of: :reverse_follows
end

class Notification < ApplicationRecord
  belongs_to :user, inverse_of: :notifications
  belongs_to :sender, class_name: "User", optional: true, inverse_of: :sent_notifications
end

class Community < ApplicationRecord
  has_and_belongs_to_many :users, inverse_of: :communities
end

# STI (Single Table Inheritance) models for User
class AdminUser < User
  has_many :audit_logs, foreign_key: :admin_user_id, inverse_of: :admin_user, dependent: :destroy
end

class RegularUser < User
  # Regular users have all the base User associations but no admin-specific ones
end

# AdminUser-specific model
class AuditLog < ApplicationRecord
  belongs_to :admin_user, class_name: "AdminUser", inverse_of: :audit_logs
end

MODELS = [User, Post, Tag, Profile, Avatar, Follow, Notification, Community].freeze
MODELS_WITH_STI = [User, AdminUser, RegularUser, Post, Tag, Profile, Avatar, Follow, Notification, Community, AuditLog].freeze
