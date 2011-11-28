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

    # Props

    create_table :scene_props do |t|
      t.integer :scene_id,              null: false
      t.integer :prop_id,               null: false
      t.string  :prop_type, limit: 100, null: false
    end

    create_table :dual_bar_graph_props do |t|
      t.integer :left_query_id,  null: false
      t.integer :right_query_id, null: false

      t.float   :left_extent,    null: false
      t.float   :right_extent,   null: false
    end

    create_table :prop_states do |t|
      t.integer :prop_id,   null: false
      t.string  :prop_type, null: false

      t.string  :key,       null: false
      t.float   :value,     null: false
    end

    add_index :prop_states, [ :prop_id, :prop_type ]
  end
end
