# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, if_not_exists: true do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :role

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
