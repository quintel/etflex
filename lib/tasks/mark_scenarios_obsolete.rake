namespace :etflex do
  desc <<-DESC
    Marks all scenarios to be obsolete. This is usually done after a deploy
    of ETengine/ETSource that renders the scenarios obsolete or outdated.
  DESC

  task mark_scenarios_obsolete: :environment do
    require 'etflex'

    scenarios = Scenario.where(obsolete: false)

    count = scenarios.count

    scenarios.each do |scenario|
      scenario.obsolete = true
      scenario.save!
    end

    puts "I have marked #{ count } scenario(s) to be obsolete."
    puts "Bye bye."

  end
end
