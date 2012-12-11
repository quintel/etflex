class AddScorePropertyToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :score_property, :string
    Scene.find(1).update_attributes({ :name_key => 'modern', :score_property => 'etflex_score' })
  end
end
