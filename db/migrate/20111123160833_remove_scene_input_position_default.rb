class RemoveSceneInputPositionDefault < ActiveRecord::Migration
  def up
    change_column :scene_inputs, :position, :integer, null: true, default: nil
  end

  def down
    change_column :scene_inputs, :position, :integer, null: false, default: 0
  end
end
