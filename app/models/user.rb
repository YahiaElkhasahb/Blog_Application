require 'bcrypt'

class User < ApplicationRecord
  has_secure_password
  has_one_attached :image
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  def self.from_token_payload(payload)
    find(payload['sub'])
  end

  def generate_token
    JWT.encode({ sub: id }, Rails.application.secrets.secret_key_base)
  end

  has_many :posts, foreign_key: 'author_id', dependent: :destroy
end
