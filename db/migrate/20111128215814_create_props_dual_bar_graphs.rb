class CreatePropsDualBarGraphs < ActiveRecord::Migration
  def change
    create_table :dual_bar_graph_props do |t|
      t.integer :left_query_id,  null: false
      t.integer :right_query_id, null: false

      t.float   :left_extent,    null: false
      t.float   :right_extent,   null: false
    end
  end
end
