#!/bin/bash
output_path='/home/gabor/move_files/p2/OUTPUT/'
docker_input='/home/gabor/move_files/p2/DOCKER/'

inotifywait --monitor --format "%e %w%f" -e moved_to ${output_path}P01_OUT_051 ${output_path}P01_OUT_175 ${output_path}P01_OUT_COM ${output_path}P02_OUT_051 ${output_path}P02_OUT_073 ${output_path}P02_OUT_COM ${output_path}P03_OUT_051 ${output_path}P03_OUT_073 ${output_path}P03_OUT_COM ${output_path}P04_OUT_051 ${output_path}P04_OUT_073 ${output_path}P04_OUT_COM ${output_path}P05_OUT_051 ${output_path}P05_OUT_073 ${output_path}P05_OUT_COM | while read changed; do
echo $changed
if [[ "$changed" == *"MOVED_TO $output_path"* ]]; then
	folder_prefix="MOVED_TO $output_path"
	folder=${changed#"MOVED_TO $output_path"}
	folder="${folder%/*}"

	file=${changed#"MOVED_TO "}

	type="${changed: -3}"

	#echo "folder: $folder"
	#echo "file: $file"
	#echo "type: $type"
	if [[ "${changed: -8}" != ".shp.sml" ]]; then
	case "${folder:0:3}" in
		"P01") 
			cp $file ${docker_input}RHK/UC04RHK/$folder.$type;;
		"P02") 
			cp $file ${docker_input}BVH/UC08BVH/$folder.$type
			cp $file ${docker_input}BKV/UC17BKV/$folder.$type;;
		"P03")
			cp $file ${docker_input}LAF/UC12LAF/$folder.$type
			cp $file ${docker_input}LAF/UC13LAF/$folder.$type
			cp $file ${docker_input}LAF/UC14LAF/$folder.$type
			cp $file ${docker_input}LAF/UC20LAF/$folder.$type
			cp $file ${docker_input}LAF/UC21LAF/$folder.$type;;
		"P04")
			cp $file ${docker_input}BKV/UC18BKV/$folder.$type;;
		"P05")
			cp $file ${docker_input}BKV/UC19BKV/$folder.$type;;
	esac
	fi
fi
done
