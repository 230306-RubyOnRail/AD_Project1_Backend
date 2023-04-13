class User < ApplicationRecord
  has_many :reimbursements
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  # Used for digesting password within our Tests
  def self.digest(password)
    BCrypt::Password.create(password)
  end
end
