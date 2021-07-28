#!/bin/bash

# Original Author : W3NDO
# Author: Deville_ee
# Edit  : Deville_ee
# Creation date : 28-07-2021

About="This script organizes a specific target folder by file types and moves these into a desinated folder"

#Specify the target folder
target_folder="$HOME/Downloads"

audio_f="Audio_files"
video_f="Video_files"
pdf_f="PDF_files"
docs_f="Word_docs"
power_f="Powerpoints"
scripts_f="Scripts"
image_f="Image_files"
note_f="Notebooks_files"
pack_f="Debian_files"
archive_f="Compressed_files"
rar_f="TXZ_files"

folder_array=( "${audio_f}" "${video_f}" "${pdf_f}" "${docs_f}" "${power_f}" "${script_f}" "${image_f}" "${spread_f}" "${note_f}" "${debian_f}" "${compr_f}" "${txz_f}")

audio_array=( "*.mp3" "*.m4a" "*.flac" "*.aac" "*.ogg" "*.wav" )
video_array=("*.mp4" "*.mov" "*.avi" "*.mpg" "*.mpeg" "*.webm" "*.mpv" "*.mp2" "*.wmv" )
pdf_array=("*.pdf")
docs_array=("*.doc" "*.docx" "*.txt" "*.odt" "*.xls")
power_f=("*.ppt" "*.pptx")
scripts_array=("*.py" "*.rb" "*.sh")
image_array=( "*.png" "*.jpg" "*.jpeg" "*.tif" "*.tiff" "*.bpm" "*.gif" "*.eps" "*.raw" )
note_array=("*.ipynb")
pack_array=("*.deb" "*.pkg.tar.xz" )
archive_array=("*.tar.*" "*.xz" "*.txz" "*.tgz" "*.7z")
rar_array=("*.zip" "*.rar" "*.iso" "*.img" )

echo "Organizing your messy ${target_folder} folder"

function create_folder()
{
    if [[ ! -d "${1}"  ]]
    then
        mkdir -p "${1}"
    fi
}

export -f create_folder

function move_file()
{
    create_folder "${2}"
    mv "${1}" "${2}"
}

export -f move_file

function sorting()
{
    arr=("$@")
    arr_len=${#arr[@]}

    for (( i=1; i<${arr_len} ; i++ ))
    do
       find "${target_folder}" -maxdepth 1 -path "${target_folder}/${1}" -prune -false -o -iname "${arr[$i]}"  -exec /bin/bash -c "move_file '{}' \"${target_folder}/${1}\"" \;
    done
}

#Audio Files
sorting "${audio_f}"    "${audio_array[@]}"
sorting "${video_f}"    "${video_array[@]}"
sorting "${pdf_f}"      "${pdf_array[@]}"
sorting "${power_f}"    "${power_array[@]}"
sorting "${docs_f}"     "${docs_array[@]}"
sorting "${scripts_f}"  "${scripts_array[@]}"
sorting "${image_f}"    "${image_array[@]}"
sorting "${note_f}"     "${note_array[@]}"
sorting "${pack_f}"     "${pack_array[@]}"
sorting "${archive_f}"  "${archive_array[@]}"
sorting "${rar_f}"      "${rar_array[@]}"

echo "All sorted!!"

