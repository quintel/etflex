class AddGroupToInputs < ActiveRecord::Migration
  def up
    add_column :inputs, :group, :string, length: 50
    add_index  :inputs, :group

    Input.reset_column_information

    say_with_time 'Adding group data to inputs' do
      YAML.load_file(Rails.root.join('db/seeds/inputs.yml')).each do |data|
        if input = Input.find_by_remote_id(data['remote_id'])
          input.group = data['group']
          input.save!
        end
      end
    end
  end

  def down
    remove_column :inputs, :group
  end
end
