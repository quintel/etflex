class AddScorePropertyToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :score_gquery, :string
    Scene.find(1).update_attributes({ :name_key => 'modern', :score_gquery => 'etflex_score' })
  end
end
