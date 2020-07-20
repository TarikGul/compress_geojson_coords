module GeojsonHelpers

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

            # set the features coordinate at x index to the new mapped object
      features[i]["geometry"]["coordinates"] = mapped
    end

    hash
  end

  def parseNum nums 
    new_coords = []

    if(nums.length === 3)
      nums.pop
    end

    nums.each do |num|
      arr = num.to_s.split('.')
    
      if arr[1] == "undefined"
        new_coords << arr.join('.')
        break;
      elsif arr[1].length < 6
        new_coords << arr.join('.')
        break;
      end

      arr[1] = arr[1][0...6]
      new_coords << arr.join('.').to_f
    end

    new_coords
  end
   
end

class Geojson
  include GeojsonHelpers

  def initialize
    
  end
end