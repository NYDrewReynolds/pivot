class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.integer :restaurant_id
      t.integer :staff_role_id

      t.timestamps null: false
    end
  end
end
