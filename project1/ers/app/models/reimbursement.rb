class Reimbursement < ApplicationRecord
  belongs_to :user # Reimbursements belong to users, users have many reimbursements
  validates :date_of_expense, numericality: { only_integer: true }, allow_nil: false
  # validates :amount, numericality: { only_integer: true }, allow_nil: false
end
