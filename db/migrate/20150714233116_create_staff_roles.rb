class CreateStaffRoles < ActiveRecord::Migration
  def change
    create_table :staff_roles do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
