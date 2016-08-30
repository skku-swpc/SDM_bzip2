#!/bin/bash

# input files
path=../inputs
files=(SPEC_BZ_64 linux-3.6.1.tar mozilla-1.7.13-source.tar Python-3.3.0.tar)

# num_process
np_min=2
np_max=3

# chunk_size
cs=1

# merge_method
mm=1

loop_cnt=5

rm -rf log
mkdir log

#for file in $path/*
for file in "${files[@]}"
do
	
	if [ ! -d log/$file ]; then
		mkdir log/$file
	fi

	logpath=log/$file
	INPUT=${path}/${file}
	for (( np=$np_min; np<$np_max; np++ )); do
		printf "num_process %d\n" "$np" > papl.conf
		printf "chunk_size %d\n" "$cs" >> papl.conf
		printf "merge_method %d\n" "$mm" >> papl.conf

		for (( i=0; i<$loop_cnt; i++ ))
		do
			rm $INPUT
			echo "$file]] worker $np]] $i.."
			./bzip2 -dk $INPUT.bz2 >> $logpath/$np
		done
		echo "" >> $logpath/$np
	done
done


clear
for file in "${files[@]}"; do
	INPUT=${path}/${file}
	printf '\e[1;33m%s\e[m\n' "$INPUT"
	for (( np=$np_min; np<$np_max; np++ )); do
		echo ""
		printf '%d\n' "$np"
		cat ./log/$file/$np
	done
	printf '\e[1;42m%s\e[m\n' " DONE "
done
