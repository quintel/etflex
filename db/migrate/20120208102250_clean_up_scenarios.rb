class CleanUpScenarios < ActiveRecord::Migration
  def up
    say_with_time 'Removing scenarios with no score' do
      Scenario.where(score: nil).delete_all
    end

    say_with_time 'Updating scenarios with no age' do
      Scenario.where(created_at: nil).each do |scenario|
        scenario.created_at = 1.day.ago
        scenario.save!
      end
    end
  end

  def down
  end
end
