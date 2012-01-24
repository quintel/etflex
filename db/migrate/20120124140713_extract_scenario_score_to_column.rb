class ExtractScenarioScoreToColumn < ActiveRecord::Migration
  def change
    add_column :scenarios, :score, :float
  end
end
