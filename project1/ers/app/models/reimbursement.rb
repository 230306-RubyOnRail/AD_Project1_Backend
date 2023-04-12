class Reimbursement < ApplicationRecord
  belongs_to :user # Reimbursements belong to users, users have many reimbursements

end
