class User < ApplicationRecord
  has_many :reimbursement_lists, dependent: :destroy
  has_many :reimbursements, through: :reimbursement_lists
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
end
