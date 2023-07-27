#!/bin/bash
output_path='/home/gabor/move_files/p2/OUTPUT/'
docker_input='/home/gabor/move_files/p2/DOCKER/'

files=0

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
	if [[ "${changed: -8}" != ".shp.sml" ]]; then # fájlok másolása a Docker mappába
		case "${folder:0:3}" in
			"P01")
				cp $file ${docker_input}RHK/UC04RHK/$folder.$type
				files=$((files+1))
				if [ "$files" == "4" ]; then
                        		cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/RHK/UC04RHK>#1" /home/gabor/move_files/config.yaml
					echo "sudo docker compose run --env USE_CASE_ID=04 geoproc-app-python"
					files=0
				fi;;
			"P02")
				cp $file ${docker_input}BVH/UC08BVH/$folder.$type
				cp $file ${docker_input}BKV/UC17BKV/$folder.$type
				files=$((files+1))
				if [ "$files" == "4" ]; then
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/BVH/UC08BVH>#1" /home/gabor/move_files/config.yaml
                                        echo "sudo docker compose run --env USE_CASE_ID=08 geoproc-app-python"
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/BKV/UC17BKV>#1" /home/gabor/move_files/config.yaml
                                	echo "sudo docker compose run --env USE_CASE_ID=17 geoproc-app-python"
					files=0
				fi;;
			"P03")
				cp $file ${docker_input}LAF/UC12LAF/$folder.$type
				cp $file ${docker_input}LAF/UC13LAF/$folder.$type
				cp $file ${docker_input}LAF/UC14LAF/$folder.$type
				cp $file ${docker_input}LAF/UC20LAF/$folder.$type
				cp $file ${docker_input}LAF/UC21LAF/$folder.$type
				files=$((files+1))
				if [ "$files" == "4" ]; then
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/LAF/UC12LAF>#1" /home/gabor/move_files/config.yaml
                                	echo "sudo docker compose run --env USE_CASE_ID=12 geoproc-app-python"
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/LAF/UC13LAF>#1" /home/gabor/move_files/config.yaml
                                        echo "sudo docker compose run --env USE_CASE_ID=13 geoproc-app-python"
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/LAF/UC14LAF>#1" /home/gabor/move_files/config.yaml
                                        echo "sudo docker compose run --env USE_CASE_ID=14 geoproc-app-python"
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/LAF/UC20LAF>#1" /home/gabor/move_files/config.yaml
                                        echo "sudo docker compose run --env USE_CASE_ID=20 geoproc-app-python"
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/LAF/UC21LAF>#1" /home/gabor/move_files/config.yaml
                                        echo "sudo docker compose run --env USE_CASE_ID=21 geoproc-app-python"
					files=0
				fi;;
			"P04")
				cp $file ${docker_input}BKV/UC18BKV/$folder.$type
				files=$((files+1))
				if [ "$files" == "4" ]; then
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/BKV/UC18BKV>#1" /home/gabor/move_files/config.yaml
                                	echo "sudo docker compose run --env USE_CASE_ID=18 geoproc-app-python"
					files=0
				fi;;
			"P05")
				cp $file ${docker_input}BKV/UC19BKV/$folder.$type
				files=$((files+1))
				if [ "$files" == "4" ]; then
                                        cat /home/gabor/move_files/config.yaml | sed -e "0,/source:.*/ s#source: .*#source: </media/STORE/data/input/BKV/UC19BKV>#1" /home/gabor/move_files/config.yaml
                                	echo "sudo docker compose run --env USE_CASE_ID=19 geoproc-app-python"
					files=0
				fi;;
		esac
		#if [[ "$files" == "4" ]]; then
		#	files=0
		#fi
	fi
fi
done
