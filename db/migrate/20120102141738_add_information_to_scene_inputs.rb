# encoding: utf-8

class AddInformationToSceneInputs < ActiveRecord::Migration
  def up
    translations = YAML.load_file(Rails.root.join('db/seeds/scenes.yml'))

    add_column :scene_inputs, :information_en, :text
    add_column :scene_inputs, :information_nl, :text

    # Add existing translations.
    Scene.all.each do |scene|
      # Extract the information strings from the seeds file.
      if scene_t = translations.detect { |seed| seed['name'] == scene.name }

        scene_t = scene_t['inputs']['left'].merge(
                  scene_t['inputs']['right'])

        scene.scene_inputs.each do |input|
          input.information_en = scene_t[input.remote_id]['information_en']
          input.information_nl = scene_t[input.remote_id]['information_nl']

          input.save!
        end
      end
    end
  rescue StandardError => e
    down
    raise e
  end

  def down
    remove_column :scene_inputs, :information_en
    remove_column :scene_inputs, :information_nl
  rescue
  end
end
