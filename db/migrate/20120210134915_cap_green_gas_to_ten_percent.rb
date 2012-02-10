class CapGreenGasToTenPercent < ActiveRecord::Migration
  def input
    Input.where(remote_id: 488).first
  end

  def scene_inputs
    SceneInput.where(input_id: input.id)
  end

  def up
    input.update_attributes! max: 10

    scene_inputs.each do |si|
      si.update_attributes!(max: 10) if si.max.present?
    end

    say 'Reduced green gas maximum to 10%'
  end

  def down
    input.update_attributes! max: 20

    scene_inputs.each do |si|
      si.update_attributes!(max: 20) if si.max.present?
    end

    say 'Reduced green gas maximum to 20%'
  end
end
