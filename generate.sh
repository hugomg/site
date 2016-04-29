#!/bin/bash

source ./config.sh
[ "$output_dir" ] || { echo "Couldn't load config.sh"; exit 1 ;}

# Make paths absolute
root_dir="$(dirname "$0")"
pages_dir=$(readlink -f "$root_dir/$pages_dir")
output_dir=$(readlink -f "$root_dir/$output_dir")
common_dir=$(readlink -f "$root_dir/$common_dir")


# Reset output dir
mkdir -p "$output_dir"
rm -rf "$output_dir/*"


# Static assets
for data_dir in ${extras_data[@]}; do
   data_dir=$(readlink -f "$root_dir/$data_dir")
   cp -r "$data_dir" "$output_dir"
done

# Generated pages
cd "$pages_dir"
find . -type f | while read file
do
   file_dir=$(dirname "$file")
   mkdir -p "$output_dir/$file_dir"
   output_file="$output_dir/$file"
   cat "$common_dir/header.html" $file "$common_dir/footer.html" > "$output_file"
done
