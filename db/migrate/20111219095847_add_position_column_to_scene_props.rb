class AddPositionColumnToSceneProps < ActiveRecord::Migration
  def change
    add_column :scene_props, :position, :integer
  end
end
