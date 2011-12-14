class AddColumnsToSceneProps < ActiveRecord::Migration
  def change
    add_column :scene_props, :hurdles, :text
  end
end