namespace :etflex do
  desc <<-DESC
    Transforms the prop map defined in config/prop_map.yml into something
    useable by the CoffeeScript client. Output to client/lib/prop_map.coffee.
  DESC

  task :generate_prop_map do
    path = Rails.root.join('client/lib/prop_map.coffee')
    map  = YAML.load_file(Rails.root.join('config/prop_map.yml'))
    file = File.read(path)

    split_file = file.split(/^module\.exports =$/)

    map_lines = map.each_with_object([]) do |(behave, vals), lines|
      # lines.push "  '#{behave}': loadProp('#{ vals[0] }', '#{ vals[1] }')"
      lines.push "  '#{behave}': { path: '#{vals[0]}', klass: '#{vals[1]}' }"
    end

    map_lines.unshift 'module.exports ='
    map_lines.unshift split_file.first.strip

    File.open(path, 'w') { |f| f.puts map_lines.join("\n") }

    puts "Written map to #{path}"
  end
end
