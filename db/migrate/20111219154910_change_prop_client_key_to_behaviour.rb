class ChangePropClientKeyToBehaviour < ActiveRecord::Migration
  def change
    rename_column :props, :client_key, :behaviour
  end
end
