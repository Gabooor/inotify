#!/bin/bash

if [ -z "$(which inotifywait)" ]; then
echo "inotifywait not installed."
exit 1
fi

counter=0; # számláló, eltárolja a betöltött fájlok mennyiségét
# fájlok nevei
file1=''
file2=''
file3=''
file4=''
file5=''

# eseménysor figyeléséhez változók
first_open=false
created=false
second_open=false
first_close=false

# változók visszaállítása betöltés után
function resetvariables() {
file1=''
file2=''
file3=''
file4=''
file5=''
counter=0
first_open=false
created=false
second_openn=false
first_close=false
from_prefix=''
output_folder=''
to_prefix=''
to_filename=''
new_filename=''
file_type=''
}

# fájlok betöltése az adott mappá(k)ba
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

output_path='/home/gabor/move_files/output_folders/'
mid_path='/home/gabor/move_files/mid_folder'
input_path='/home/gabor/move_files/input_folders/'

inotifywait --monitor --format "%e %w%f" -e open,create,close_write,close ${mid_path} ${output_path}P01_OUT_051 ${output_path}P01_OUT_175 ${output_path}P01_OUT_COMB ${output_path}P02_OUT_051 ${output_path}P02_OUT_073 ${output_path}P02_OUT_COMB ${output_path}P03_OUT_051 ${output_path}P03_OUT_073 ${output_path}P03_OUT_COMB ${output_path}P04_OUT_051 ${output_path}P04_OUT_073 ${output_path}P04_OUT_COMB ${output_path}P05_OUT_051 ${output_path}P05_OUT_073 ${output_path}P05_OUT_COMB | while read changed; do
        echo $changed
        # ESEMÉNYSOR FIGYELÉSE: OPEN -> CREATE -> OPEN -> CLOSE_NOWRITE,CLOSE -> CLOSE_WRITE,CLOSE = VÉGREHAJTÓDOTT A FÁJL MÁSOLÁSA
        if [[ "$changed" == *"OPEN $output_path"* ]]; then
                from_prefix="OPEN /home/gabor/move_files/output_folders/"
                output_folder=${changed#"$from_prefix"}
                output_folder="${output_folder%%/*}"
                first_open=true
        elif [[ "$changed" == *"CREATE $mid_path/"* ]] && [ "$first_open" == "true" ]; then
                created=true
        elif [[ "$changed" == *"OPEN $mid_path/"*  ]] && [ "$created" == "true"  ]; then
                second_open=true
        elif [[ "$changed" == *"CLOSE_NOWRITE,CLOSE $output_path"* ]] && [ "$second_open" == "true" ]; then
                first_close=true
        elif [[ "$changed" == *"CLOSE_WRITE,CLOSE $mid_path/"* ]] && [ "$first_close" == "true" ]; then
                to_prefix='CLOSE_WRITE,CLOSE '
                to_filename=${changed#"$to_prefix"} # /media/STORE/InSAR4HU_MID/XYZ.shp
                new_filename="${to_filename%/*}" # /media/STORE/InSAR4HU_MID
                file_type=${to_filename: -3}
                if [ "$file_type" == "sml" ]; then
                        new_filename="$new_filename/$output_folder.shp.sml"
                else
                        new_filename="$new_filename/$output_folder.$file_type"
                fi
                if [ "$to_filename" != "$new_filename" ]; then
                        mv $to_filename $new_filename # átnevezés
                        case $counter in
                                0) file1=$new_filename;;
                                1) file2=$new_filename;;
                                2) file3=$new_filename;;
                                3) file4=$new_filename;;
                                4) file5=$new_filename;;
                        esac
                        echo "File1: $file1"
                        echo "File2: $file2"
                        echo "File3: $file3"
                        echo "File4: $file4"
                        echo "File5: $file5"
                        echo "------------"
                        if [ $counter == 4 ]; then
                                case "${output_folder:0:3}" in
                                        "P01") 
                                                loadfiles "${input_path}RHK/UC04RHK"
                                                resetvariables;;
                                        "P02")
                                                loadfiles "${input_path}BVH/UC08BVH"
                                                loadfiles "${input_path}BKV/UC17BKV"
                                                resetvariables;;
                                        "P03")
                                                loadfiles "${input_path}LAF/UC12LAF"
                                                loadfiles "${input_path}LAF/UC13LAF"
                                                loadfiles "${input_path}LAF/UC14LAF"
                                                loadfiles "${input_path}LAF/UC20LAF"
                                                loadfiles "${input_path}LAF/UC21LAF"
                                                resetvariables;;
                                        "P04")
                                                loadfiles "${input_path}BKV/UC18BKV"
                                                resetvariables;;
                                        "P05")
                                                loadfiles "${input_path}BKV/UC19BKV"
                                                resetvariables;;
                                esac
                        else
                                counter=$((counter+1))
                        fi
                fi
                output_folder=''
                first_open=false
                created=false
                second_open=false
                first_close=false
        fi
done
