class CreateEtliteScene < ActiveRecord::Migration
  def up
    scene = Scene.create name: 'ETlite Recreation'

    inputs = Input.all.each_with_object({}) do |input, dict|
      dict[ input.remote_id ] = input
    end

    scene_input_count = SceneInput.count

    SceneInput.create scene: scene, input: inputs[43]
    SceneInput.create scene: scene, input: inputs[146]
    SceneInput.create scene: scene, input: inputs[336]
    SceneInput.create scene: scene, input: inputs[348]
    SceneInput.create scene: scene, input: inputs[366]
    SceneInput.create scene: scene, input: inputs[338]

    SceneInput.create scene: scene, input: inputs[315], placement: true
    SceneInput.create scene: scene, input: inputs[256], placement: true
    SceneInput.create scene: scene, input: inputs[259], placement: true
    SceneInput.create scene: scene, input: inputs[263], placement: true
    SceneInput.create scene: scene, input: inputs[313], placement: true
    SceneInput.create scene: scene, input: inputs[196], placement: true

    difference = SceneInput.count - scene_input_count

    if difference != 12
      down

      raise "The SceneInputs were not all created. Has validation changed " \
            "since the migration was written? (Made #{difference})."
    end

  end

  def down
    scene = Scene.where(name: 'ETlite Recreation').first

    SceneInput.where(scene_id: scene.id).each(&:destroy)
    scene.destroy
  end
end
