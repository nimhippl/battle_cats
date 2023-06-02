class User < ApplicationRecord
  has_secure_password
  validates :email, :username, uniqueness: true, presence: true
  has_many :records
end
