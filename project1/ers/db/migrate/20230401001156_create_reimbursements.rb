class CreateReimbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :reimbursements, if_not_exists: true do |t|

      t.timestamps
    end
  end
end
