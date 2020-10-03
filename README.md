# Welcome to the Geojson Script

## TODO
-Im currently working on the src file and turning this into a more usable library with some more options, and user control.
-I need to optimize the algorithm to calculate and reference the change in degree per line in order to find more redundancies

The goal of this script is to allow you to compress your file size for you geojson files by 
lowering the length of your coordinates. By mapbox's standard for large geojson file it
is recommended to have them at a length of 6 decimal places. I also lower the 
file size by removing whitespace in you geojson. You can convert as many files as youd like.
Place all your geojson files in the directory /json_files.

```
    bundle install
```

After you have placed your geojson files in /json_files

```
    ruby execute.rb
```


you will then see all your new files in a /generated_json directory


