#!/bin/bash

# Original Author : W3NDO
# Author: Deville_ee
# Edit  : Deville_ee
# Creation date : 28-07-2021
# Edit date : 30-07-2021

OLD_IFS=$IFS
IFS="
"

version="3"

# Version 3   # Add an external config file which will be used as a guide line to organize your folder system. When no config file exists a new one will be created 
#             # With the current file system as a guideline (Handy in order to backup your folder structure). 
#             # Add extra root execution check
# Version 2.3 # Change all ${HOME} Variables to ${HOME} to maintain compatibility.
# Version 2.2 # Add Extra extensions like: MTS APK WEBP
# Version 2.1 # Add extra function for the creation of your personal folders. Add Your folders to the "extra_folders" array
# Version 2   # Forked the original W3NDO script https://github.com/W3NDO/Organize and add a routine for the file organisation. In this way only folders which are needed are created. 

# Todo  : Determine a system to conquer the perpetual choice if the files are rubbish or not. The idea of distributing these into specialized folder's root can make a good start.
#         This will keep in fact your Downloads folder clean and forces you to maintain a folder structure in the other parts of your ${HOME} folder.
#
# Ideas :  + Remove the folders which became empty? Maybe keep a list of previous folder structure in order to re-install a previous folder structure.
#
#          + Scan the folder structure and add the amount of files to the folder's name
#          + Add a rule system
#          + Add file overwrite detection



About="This script organizes a specific target folder by file types and moves the into a designated folder"

#Specify the target folder
target_folder="${HOME}/Downloads"

#Specify the config file
config_file="folder_structure.config"



extra_folders=("${HOME}/Pictures/" )

audio_array=( "*.mp3" "*.m4a" "*.flac" "*.aac" "*.ogg" "*.wav" )
video_array=("*.mp4" "*.mov" "*.avi" "*.mpg" "*.mpeg" "*.webm" "*.mpv" "*.mp2" "*.wmv" "*.MTS" )
pdf_array=("*.pdf")
docs_array=("*.doc" "*.docx" "*.odt" "*.xls")
text_array=("*.txt")
power_array=("*.ppt" "*.pptx")
scripts_array=("*.py" "*.rb" "*.sh")
image_array=( "*.png" "*.jpg" "*.jpeg" "*.tif" "*.tiff" "*.bpm" "*.gif" "*.eps" "*.raw" "*.webp" )
note_array=("*.ipynb")
pack_array=("*.deb" "*.pkg.tar.xz" ".apk" )
archive_array=("*.tar.*" "*.xz" "*.txz" "*.tgz" "*.7z")
rar_array=("*.zip" "*.rar" "*.iso" "*.img" )

function create_config_file()
{
    echo "# This config file will be used as a guideline by organize.sh"  > ${config_file}
    echo -e "# Add folders here under 'extra folders' in order to create automatically your disired folder structure\n\n" >> ${config_file}
    echo "audio_f="$\{HOME\}/Music"" >> ${config_file}
    echo "video_f="$\{HOME\}/Videos"" >> ${config_file}
    echo "pdf_f="$\{HOME\}/Documents/Office/PDF_Files"" >> ${config_file}
    echo "docs_f="$\{HOME\}/Documents/Office/Word_Docs"" >> ${config_file}
    echo "txt_f="$\{HOME\}/Documents/Office/Text_Files"" >> ${config_file}
    echo "power_f="$\{HOME\}/Documents/Office/Powerpoints"" >> ${config_file}
    echo "scripts_f="$\{HOME\}/Documents/Script_Collection"" >> ${config_file}
    echo "image_f="$\{HOME\}/Pictures"" >> ${config_file}
    echo "note_f="$\{HOME\}/Documents/Office/Notebooks_Files"" >> ${config_file}
    echo "pack_f="$\{HOME\}/Documents/Archives/Debians"" >> ${config_file}
    echo "archive_f="$\{HOME\}/Documents/Archives/Tarballs"" >> ${config_file}
    echo -e "rar_f="$\{HOME\}/Documents/Archives/Compresses_Files"\n\n" >> ${config_file}
    echo "extra_folders=(" >> ${config_file}

    for path in $(find ~/  -maxdepth 2  -not -path '*/\.*' -type d  -iname "[a-z]*"  | uniq)
    do
        echo "${path}" | sed "s#${HOME}#$\{HOME\}#"  >> ${config_file}
    done

    echo -e  ")\n\n" >> ${config_file}
    echo "folder_array=( "$\{audio_f\}" "$\{video_f\}" "$\{pdf_f\}" "$\{docs_f\}" "$\{power_f\}" "$\{script_f\}" "$\{image_f\}" "$\{spread_f\}" "$\{note_f\}" "$\{debian_f\}" "$\{compr_f\}" "$\{txz_f\}")"  >>  ${config_file}


}

function create_folder()
{
    if [[ ! -d "${1}"  ]]
    then
        echo "INFO: Creating folder: ${1}"
        mkdir -p "${1}"
    fi
}

export -f create_folder

function move_file()
{
    create_folder "${2}"
    echo "INFO: Moving file : ${1}  to ${2}"
    mv "${1}" "${2}"
}

export -f move_file

function sorting()
{
    arr=("$@")
    arr_len=${#arr[@]}

    for (( i=1; i<${arr_len} ; i++ ))
    do
       find -L "${target_folder}" -maxdepth 1 -path "${target_folder}/${1}" -prune -false -o -iname "${arr[$i]}"  -exec /bin/bash -c "move_file '{}' ${1}" \;
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

if [[ $(id -u) -eq 0 ]]
then
    echo "ERROR: You are the super user, execute the script as the normal user ($USER)"
    exit 1
fi

if [[ ! -e ${config_file} ]]
then
    echo "WARNING: ${config_file} not found on this system, creating a new template based on this system's folder structure"
    create_config_file
    exit 1
else
    source ${config_file}
fi

create_extra_folders  "${extra_folders[@]}"

echo "Organizing your messy ${target_folder} folder"

sorting "${audio_f}"    "${audio_array[@]}"
sorting "${video_f}"    "${video_array[@]}"
sorting "${pdf_f}"      "${pdf_array[@]}"
sorting "${power_f}"    "${power_array[@]}"
sorting "${docs_f}"     "${docs_array[@]}"
sorting "${txt_f}"     "${text_array[@]}"
sorting "${scripts_f}"  "${scripts_array[@]}"
sorting "${image_f}"    "${image_array[@]}"
sorting "${note_f}"     "${note_array[@]}"
sorting "${pack_f}"     "${pack_array[@]}"
sorting "${archive_f}"  "${archive_array[@]}"
sorting "${rar_f}"      "${rar_array[@]}"

echo "All sorted!!"

IFS=$OLD_IFS

