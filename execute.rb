require 'rubygems'
require 'json'

# Before you run anything make sure to put all the json files you want
# parsed and compressed inside the json_files folder
files_to_rewrite = Dir.entries("json_files").select {|f| !File.directory? f}

def refactorJsonCoordinates hash 
  # This will return an array of all our features
  features = hash["features"]
  
  # Read each feature inside of our geojson files
  features.each.with_index do |feature, i|

    f = feature["geometry"]["coordinates"]
    
    # memoize the array and then we will replace the coords array in the hash
    mapped = f.map do |arr| 
        parseNum(arr)
    end

    # set the 
    features[i]["geometry"]["coordinates"] = mapped
  end

  hash
end

# This will shorten the length of the lng and lat to be 6 decimal places long
def parseNum nums 
  new_coords = []

  nums.each do |num|
    arr = num.to_s.split('.')

    arr[1] = arr[1][0...6]
    new_coords << arr.join('.').to_f
  end

  new_coords
end

# Create the generate_json file
if !File.directory?("generated_json")
  Dir.mkdir 'generated_json'
end

# loop through all the added json files in the json_files folder
files_to_rewrite.each do |file_path|
  
  # check to make sure that the file is a json
  if file_path.split(".")[1] != 'json' 
    puts "#{file_path} must be a .json file"
    next
  end

  # This says we want to create this file open it and write to it.
  # we access it by  writing to the file parameter
  File.open("generated_json/#{file_path}", "w") do |file|

    # read the file and memoize it
    s = File.read("json_files/#{file_path}")

    # retrieve the file size so that we can output the result. We can 
    # definitely make this more dry by turning this into a helper function
    old_file = File.size("json_files/#{file_path}")
    puts "Old file size for #{file_path} is #{File.size("json_files/#{file_path}")} Bytes" 

    # take the file we read earlier and parse the json so that we can refactor it.
    data_hash = JSON.parse(s)

    # refactor the json. We only refactor the coordinates to be a smaller length.
    # in this case we are able to decrease the file size from 10% to 36%
    # this also will rewrite the data_hash variable so we dont need to create 
    # another pointer
    refactorJsonCoordinates(data_hash)

    # Write the json to the file. We dont want to do pretty_generate as it will
    # make the file size significantly large because of the white space
    file.write(JSON.generate(data_hash))

    #Same as earlier print the new file size to the terminal
    new_file = File.size("generated_json/#{file_path}")
    puts "New file size for #{file_path} is #{File.size("generated_json/#{file_path}")} Bytes" 

    # Tell the user how much space was saved
    space_saved = 100 - ((new_file/old_file.to_f) * 100)
    puts "You decreased your file save for #{file_path} by #{space_saved}%"
  end
end
