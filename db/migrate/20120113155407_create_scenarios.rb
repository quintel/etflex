class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios, force: true do |t|
      t.integer :user_id,    null: false
      t.integer :scene_id,   null: false
      t.integer :session_id, null: false

      t.timestamps
    end

    add_index :scenarios, [ :session_id ], unique: true
  end
end
