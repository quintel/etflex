class CreateSceneProps < ActiveRecord::Migration
  def change
    create_table :scene_props do |t|
      t.integer :scene_id,              null: false
      t.integer :prop_id,               null: false
      t.string  :prop_type, limit: 100, null: false
    end
  end
end
