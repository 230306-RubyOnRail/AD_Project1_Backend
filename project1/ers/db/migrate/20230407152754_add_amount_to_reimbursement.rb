class AddAmountToReimbursement < ActiveRecord::Migration[7.0]
  def change
    add_column :reimbursements, :amount, :integer
  end
end
