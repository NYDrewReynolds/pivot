class DropReviewsTable < ActiveRecord::Migration
  def up
    drop_table :reviews
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
