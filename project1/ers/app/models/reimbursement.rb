class Reimbursement < ApplicationRecord
  belongs_to :user

  # def reimbursement_path(reimbursement)
  #   "/reimbursements/#{reimbursement.id}"
  # end
end
