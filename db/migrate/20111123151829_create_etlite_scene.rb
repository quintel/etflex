class CreateEtliteScene < ActiveRecord::Migration
  def up
    scene = Scene.create name: 'ETlite Recreation'

    inputs = Input.all.each_with_object({}) do |input, dict|
      dict[ input.remote_id ] = input
    end

    scene_input_count = SceneInput.count

    SceneInput.create scene: scene, input: inputs[43],  position: 1
    SceneInput.create scene: scene, input: inputs[146], position: 2
    SceneInput.create scene: scene, input: inputs[336], position: 3
    SceneInput.create scene: scene, input: inputs[348], position: 4
    SceneInput.create scene: scene, input: inputs[366], position: 5
    SceneInput.create scene: scene, input: inputs[338], position: 6

    SceneInput.create scene: scene, input: inputs[315], position: 1, placement: true
    SceneInput.create scene: scene, input: inputs[256], position: 2, placement: true
    SceneInput.create scene: scene, input: inputs[259], position: 3, placement: true
    SceneInput.create scene: scene, input: inputs[263], position: 4, placement: true
    SceneInput.create scene: scene, input: inputs[313], position: 5, placement: true
    SceneInput.create scene: scene, input: inputs[196], position: 6, placement: true

    if scene_input_count = 12 != SceneInput.count
      down

      raise 'The SceneInputs were not all created. Has validation changed ' \
            'since the migration was written?'
    end

  end

  def down
    scene = Scene.where(name: 'ETlite Recreation').first

    SceneInput.where(scene_id: scene.id).each(&:destroy)
    scene.destroy
  end
end
