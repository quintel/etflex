class RemoteIdFromInput < ActiveRecord::Migration
  def up
    remove_column :inputs, :remote_id
    Input.reset_column_information
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
