#!/bin/bash
 
if [ -z "$(which inotifywait)" ]; then
    echo "inotifywait not installed."
    exit 1
fi
 
counter=0;
file1=''
file2=''
file3=''
file4=''
file5='' 

first_open=false

function resetvariables() {
	file1=''
	file2=''
	file3=''
	file4=''
	file5=''
	counter=0
	first_open=false
	from_prefix=''
	output_folder=''
	to_prefix=''
	to_filename=''
	new_filename=''
	file_type=''
}

function loadfiles(){
	echo "Minden fájl átmásolva"
        if [ "${file1: -3}" != "sml" ]; then
                cp $file1 $1
        fi
        if [ "${file2: -3}" != "sml" ]; then
                cp $file2 $1
        fi
        if [ "${file3: -3}" != "sml" ]; then
                cp $file3 $1
        fi
        if [ "${file4: -3}" != "sml" ]; then
                cp $file4 $1
        fi
        if [ "${file5: -3}" != "sml" ]; then
                cp $file5 $1
        fi
}
output_path='/home/Gabooor/move_files/output_folders/'
inotifywait --monitor --format "%e %w%f" -e open,create /home/Gabooor/move_files/mid_folder ${output_path}P01_OUT_051 ${output_path}P01_OUT_175 ${output_path}P01_OUT_COMB ${output_path}P02_OUT_051 ${output_path}P02_OUT_073 ${output_path}P02_OUT_COMB ${output_path}P03_OUT_051 ${output_path}P03_OUT_073 ${output_path}P03_OUT_COMB ${output_path}P04_OUT_051 ${output_path}P04_OUT_073 ${output_path}P04_OUT_COMB ${output_path}P05_OUT_051 ${output_path}P05_OUT_073 ${output_path}P05_OUT_COMB | while read changed; do

#OUTPUT MAPPA FIGYELÉS
if [[ "$changed" == *"OPEN /home/Gabooor/move_files/output_folders/"* ]]; then
	from_prefix='OPEN /home/Gabooor/move_files/output_folders/'
	output_folder=${changed#"$from_prefix"}
	output_folder="${output_folder%%/*}"
	first_open=true
	
# MID MAPPA FIGYELÉS
elif [[ "$changed" == *"CREATE /home/Gabooor/move_files/mid_folder/"* ]] && [ "$first_open" == "true" ]; then
	to_prefix='CREATE '
	to_filename=${changed#"$to_prefix"}
	new_filename="${to_filename%/*}"
	file_type=${to_filename: -3}
	if [ "$file_type" == "sml" ]; then
		new_filename="$new_filename/$output_folder.shp.sml"
	else
		new_filename="$new_filename/$output_folder.$file_type"
	fi	
	if [ "$to_filename" != "$new_filename" ]; then
		mv $to_filename $new_filename
		case $counter in
			0) file1=$new_filename
			1) file2=$new_filename
			2) file3=$new_filename
			3) file4=$new_filename
			4) file5=$new_filename
		esac
		if [ $counter == 4 ]; then
			if [ "$output_folder" == "P01_OUT_051" ] || [ "$output_folder" == "P01_OUT_175" ] || [ "$output_folder" == "P01_OUT_COMB" ]; then
				loadfiles "/home/Gabooor/move_files/input_folders/RHK/UC04RHK"
				resetvariables
			elif [ "$output_folder" == "P02_OUT_051" ] || [ "$output_folder" == "P02_OUT_073" ]  || [ "$output_folder" == "P02_OUT_COMB" ]; then
				loadfiles "/home/Gabooor/move_files/input_folders/BVH/UC08BVH"
				loadfiles "/home/Gabooor/move_files/input_folders/BKV/UC17BKV"
				resetvariables
			elif [ "$output_folder" == "P03_OUT_051" ] || [ "$output_folder" == "P03_OUT_073" ] || [ "$output_folder" == "P03_OUT_COMB" ]; then
				loadfiles "/home/Gabooor/move_files/input_folders/LAF/UC12LAF"
				loadfiles "/home/Gabooor/move_files/input_folders/LAF/UC13LAF"
				loadfiles "/home/Gabooor/move_files/input_folders/LAF/UC14LAF"
				loadfiles "/home/Gabooor/move_files/input_folders/LAF/UC20LAF"
				loadfiles "/home/Gabooor/move_files/input_folders/LAF/UC21LAF"
				resetvariables
			elif [ "$output_folder" == "P04_OUT_051" ] || [ "$output_folder" == "P04_OUT_073" ] || [ "$output_folder" == "P04_OUT_COMB" ]; then
				loadfiles "/home/Gabooor/move_files/input_folders/BKV/UC18BKV"
				resetvariables
			elif [ "$output_folder" == "P05_OUT_051" ] || [ "$output_folder" == "P05_OUT_073" ] || [ "$output_folder" == "P05_OUT_COMB" ]; then
				loadfiles "/home/Gabooor/move_files/input_folders/BKV/UC18BKV"
				resetvariables
			fi
		else
			counter=$((counter+1))
		fi
	fi
	echo "File1: $file1"
	echo "File2: $file2"
	echo "File3: $file3"
	echo "File4: $file4"
	echo "File5: $file5"
else
        output_folder=''
        first_open=false
fi    
done