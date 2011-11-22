class CreateBlueprintInputs < ActiveRecord::Migration
  def change
    create_table :blueprint_inputs do |t|
      t.integer :blueprint_id, null: false
      t.integer :input_id,     null: false
      t.boolean :placement,    null: false, default: 0
      t.integer :position,     null: false, default: 0
    end
  end
end
