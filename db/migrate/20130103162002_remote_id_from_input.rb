class RemoteIdFromInput < ActiveRecord::Migration
  def up
    remove_column :inputs, :remote_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
