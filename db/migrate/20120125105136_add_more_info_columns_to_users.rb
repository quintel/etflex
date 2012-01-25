class AddMoreInfoColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name,   :string
    add_column :users, :image,  :string
    add_column :users, :origin, :string
    add_column :users, :token,  :string
    add_column :users, :uid,    :string
  end
end