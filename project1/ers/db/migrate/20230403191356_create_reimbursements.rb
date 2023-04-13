class CreateReimbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :reimbursements do |t|
      t.string :expense_type
      t.integer :date_of_expense
      t.string :additional_comments
      t.string :status
      t.integer :amount
      t.references :user, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
