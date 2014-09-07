class User < ActiveRecord::Base
  include Tokenable

  has_secure_password
  VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  
  validates :user_name, presence: true, format: { without: /\s/, message: "No spaces in user name!"  }, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 6}

  validates_inclusion_of :terms, in: [true]

  extend FriendlyId
  friendly_id :user_name, use: :slugged

  has_and_belongs_to_many :stores
  has_and_belongs_to_many :coupons

  has_many :transactions, dependent: :destroy
  has_many :activities, dependent: :destroy
end
