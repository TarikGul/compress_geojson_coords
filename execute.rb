require 'rubygems'
require 'json'

# Before you run anything make sure to put all the json files you want
# parsed and compressed inside the json_files folder
files_to_rewrite = Dir.entries("json_files").select {|f| !File.directory? f}

def refactorJson hash 
  # This will return an array of all our features
  features = hash["features"]
  
  # Read each feature inside of our geojson files
  features.each.with_index do |feature, i|

    f = feature["geometry"]["coordinates"]
    
    # memoize the array and then we will replace the coords array in the hash
    mapped = f.map do |arr| 
        parseNum(arr)
    end
    features[i]["geometry"]["coordinates"] = mapped
  end

  hash
end


def parseNum nums 
  new_coords = []

  nums.each do |num|
    arr = num.to_s.split('.')

    arr[1] = arr[1][0...6]
    new_coords << arr.join('.').to_f
  end

  new_coords
end

files_to_rewrite.each do |file_path|
  File.open("generated/#{file_path}", "w") do |file|

    s = File.read("json_files/cdt_mock.json")
    data_hash = JSON.parse(s)

    refactorJson(data_hash)
    file.write(JSON.pretty_generate(data_hash))
  end
end
