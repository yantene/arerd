# frozen_string_literal: true

require "active_record"

class User < ActiveRecord::Base
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

class Post < ActiveRecord::Base
  belongs_to :user, inverse_of: :posts

  has_many :tags, as: :taggable, dependent: :destroy, inverse_of: :taggable
end

class Tag < ActiveRecord::Base
  belongs_to :taggable, polymorphic: true, inverse_of: :tags
end

class Profile < ActiveRecord::Base
  belongs_to :user, inverse_of: :profile

  has_one :avatar, inverse_of: :profile, dependent: :destroy
end

class Avatar < ActiveRecord::Base
  belongs_to :profile, optional: true, inverse_of: :avatar
  has_one :user, through: :profile, inverse_of: :avatar
end

class Follow < ActiveRecord::Base
  belongs_to :follower, class_name: "User", inverse_of: :follows
  belongs_to :followee, class_name: "User", inverse_of: :reverse_follows
end

class Notification < ActiveRecord::Base
  belongs_to :user, inverse_of: :notifications
  belongs_to :sender, class_name: "User", optional: true, inverse_of: :sent_notifications
end

class Community < ActiveRecord::Base
  has_and_belongs_to_many :users, inverse_of: :communities
end

MODELS = [User, Post, Tag, Profile, Avatar, Follow, Notification, Community].freeze
