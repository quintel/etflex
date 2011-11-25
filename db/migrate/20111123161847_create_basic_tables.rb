class CreateBasicTables < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.integer :remote_id,                 null: false
      t.string  :key,                       null: false
      t.float   :step,      default:   1.0, null: false
      t.float   :min,       default:   0.0, null: false
      t.float   :max,       default: 100.0, null: false
      t.float   :start,     default:   0.0, null: false
      t.string  :unit
    end

    add_index :inputs, :remote_id, unique: true

    create_table :scene_inputs do |t|
      t.integer :scene_id,                  null: false
      t.integer :input_id,                  null: false
      t.boolean :left,      default: true,  null: false
      t.integer :position

      # Customised input values.

      t.float   :min
      t.float   :max
      t.float   :start
    end

    add_index :scene_inputs, [ :scene_id, :input_id ], unique: true

    create_table :scenes do |t|
      t.string  :name,      limit: 100
    end

    create_table :outputs do |t|
      t.string  :key,       limit: 100,     null: false
      t.string  :type_name, limit: 25,      null: false
      t.text    :type_data,                 null: false
    end
  end
end
