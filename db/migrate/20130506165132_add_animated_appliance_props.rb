class AddAnimatedApplianceProps < ActiveRecord::Migration
  def up
    man   = Prop.create!(key: 'appliances_man',  behaviour: 'appliances-man')
    girl  = Prop.create!(key: 'appliances_girl', behaviour: 'appliances-girl')

    house = Scene.where(name_key: 'house').first

    # We need to increase the position of a number of props in order to make
    # space for the new animated props.
    house.scene_props.where('location = ? AND position > ?', 'header', 5).each do |prop|
      prop.update_attributes!(position: prop.position + 2)
    end

    house.scene_props.create!(
      location: 'header', position: 6, prop_id: man.id)

    house.scene_props.create!(
      location: 'header', position: 7, prop_id: girl.id)
  end

  def down
    man  = Prop.where(key: 'appliances_man').first
    girl = Prop.where(key: 'appliances_girl').first

    house = Scene.where(name_key: 'house').first

    house.scene_props.where(prop_id: man.id).first.destroy
    house.scene_props.where(prop_id: girl.id).first.destroy

    house.scene_props.where('location = ? AND position > ?', 'header', 7).each do |prop|
      prop.update_attributes!(position: prop.position - 2)
    end

    man.destroy
    girl.destroy
  end
end
