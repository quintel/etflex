class RenameBlueprintToScene < ActiveRecord::Migration
  def change
    rename_table :blueprints,       :scenes
    rename_table :blueprint_inputs, :scene_inputs

    rename_column :scene_inputs, :blueprint_id, :scene_id
  end
end
