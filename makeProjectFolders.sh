#!/bin/bash

echo "Creating folder hierarchy for project" 


### Users can either supply a name in the program or give it as command line argument ###
### Program checks if the input directory exists and if the name is valid ###

nameIsSet=false
if [ $# -eq 0 ];then
	while [ ${nameIsSet} = false ]; do
		read -p "Enter name for project: " projname
		if [ ! -d "${PWD}/${projname}" ]; then
			nameIsSet=true
		else echo "Project exists. Please use a different name"
		fi
	done
else
	projname=${1}
	if [ -d "${PWD}/${projname}" ]; then
		echo "Project exists. Please use a different name"
		exit
	fi
fi

re='[^a-zA-Z0-9_]'

if [[ ${projname} =~ $re ]]; then
	printf "Name is invalid.\nPlease only use alphanumeric characters and _\n"
	exit
fi


### Creating main directory and subdirectories ###
mkdir "${PWD}/${projname}"
cd "${PWD}/${projname}"

dirs=("doc" "data" "src" "bin" "results")

mkdir ${dirs[@]}

echo "Done"
