class CreateReimbursementLists < ActiveRecord::Migration[7.0]
  def change
    create_table :reimbursement_lists, if_not_exists: true do |t|

      t.timestamps
    end
  end
end
