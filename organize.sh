#!/bin/bash

# Author: Deville_ee
# Edit  : Deville_ee
# Creation date : 28-07-2021
# Edit date : 30-07-2021

version="2.1"

# Version 2.1 # Add extra function for the creation of your personal folders. Add Your folders to the "extra_folders" array
# Version 2   # Forked the original W3NDO script https://github.com/W3NDO/Organize and add a routine for the file organisation. In this way only folders which are needed are created. 

# Todo : Determine a system to conquer the perpetual choice if the files are rubbish or not. The idea of distributing these into specialized folder's root can make a good start.
#        This will keep in fact your Downloads folder clean and forces you to maintain a folder structure in the other parts of your $HOME folder.
#
# Idea :  Remove the folders which became empty? Maybe keep a list of previous folder structure in order to re-install a previous folder structure.
# 


About="This script organizes a specific target folder by file types and moves the into a desinated folder"

#Specify the target folder
target_folder="$HOME/Downloads"

audio_f="$HOME/Music"
video_f="$HOME/Videos"
pdf_f="$HOME/Documents/Office/PDF_Files"
docs_f="$HOME/Documents/Office/Word_Docs"
power_f="$HOME/Documents/Office/Powerpoints"
scripts_f="$HOME/Documents/Script_Collection"
image_f="$HOME/Pictures"
note_f="$HOME/Documents/Office/Notebooks_Files"
pack_f="$HOME/Documents/Archives/Debians"
archive_f="$HOME/Documents/Archives/Tarballs"
rar_f="$HOME/Documents/Archives/Compresses_Files"

extra_folders=("$HOME/bin" "$HOME/Virtual_Machines" "$HOME/Documents/Software/Linux" "$HOME/Documents/Personal/" "$HOME/Documents/Office/Text_Files" "$HOME/Documents/Secure" "$HOME/Workspace" "$HOME/Documents/Work" "$HOME/Pictures/Work" )

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

function create_extra_folders()
{
    arr=("$@")
    arr_len=${#arr[@]}

    for (( i=0; i<${arr_len}; i++ ))
    do
        if [[ ! -d "${arr[$i]}" ]]
        then
            echo "INFO: Creating extra folder: ${arr[$i]}"
            mkdir -p "${arr[$i]}"
        fi
    done
}

create_extra_folders  "${extra_folders[@]}"

echo "Organizing your messy ${target_folder} folder"

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

