#!/bin/bash

function Sort()
{
	list=$unsorted_marks
	j=0
	for i in $list
	do
		arr[j]=$i
		let j=$j+1
	done
	for((i=0; i<=$((${#arr[@]}-1)); i++))
	do
		for((j=$i+1; j<=${#arr[@]}-1; j++))
		do
			if [[ `echo "${arr[$i]} <= ${arr[$j]}" | bc` -eq 1 ]]; then
				temp=${arr[$i]}
				arr[$i]=${arr[$j]}
				arr[$j]=$temp
			fi
		done
	done
	echo "${arr[@]}"
}

########################## finding rank of individual student ###################### 
function FindRank()
{	
	arr=$sorted_batch_marks
	mark=$s_mark
	j=0
	for i in $arr
	do
		frank[$j]=$i
		let j=$j+1
	done
	echo "$mark"
#								echo -ne "${#frank[@]} \t ${frank[@]}"
	
for((i=0; i<${#frank[@]}; i++)); do
#								echo "$i"
		check=`echo "${frank[$i]} == $mark" | bc`
		if [[ $check -eq 1 ]]; then
#			echo "inside if $i"
			rank=$(($i+1))
			#echo "$index"
#			echo "$rank"
			exit 1 
		fi
	done
}

########################generate individual student report###########################
no_of_students=`cat basic-refresher_marks.csv | wc -l`
for((i=2; i<=$no_of_students; i++)); do
	name=`cut -d',' -f1 basic-refresher_marks.csv | head -$i | tail -1`
#	echo "$name"
	mark1=`grep "$name" basic-refresher_marks.csv | cut -d',' -f8`
	mark2=`grep "$name" basic-refresher_marks.csv | cut -d',' -f9`
	mark3=`grep "$name" basic-refresher_marks.csv | cut -d',' -f10`
	mark4=`grep "$name" basic-refresher_marks.csv | cut -d',' -f11`
	mark5=`grep "$name" basic-refresher_marks.csv | cut -d',' -f12`
#	mark6=`grep "$name" basic-refresher_marks.csv | cut -d',' -f13`
	
	batch_marks1=`sed -n '2,$p' basic-refresher_marks.csv | cut -d',' -f8`
	unsorted_marks=$batch_marks1
	sorted_batch_marks=`Sort $unsorted_marks`
#echo "sorted batch marks $sorted_batch_marks"
	s_mark=$mark1
#echo "$s_mark"
	rank=`FindRank $sorted_batch_marks $s_mark`
echo "$rank"
	rank1=$rank
echo "Rank1 is $rank1"
	batch_marks2=`sed -n '2,$p' basic-refresher_marks.csv | cut -d',' -f9`
	unsorted_marks=$batch_marks2
	sorted_batch_marks=`Sort $unsorted_marks`
	s_mark=$mark2
#echo "$s_mark"
	rank=`FindRank $sorted_batch_marks $s_mark`
echo "$rank"
	rank2=$rank
echo "Rank2 is $rank2"
	batch_marks3=`sed -n '2,$p' basic-refresher_marks.csv | cut -d',' -f10`
	unsorted_marks=$batch_marks3
	sorted_batch_marks=`Sort $unsorted_marks`
	s_mark=$mark3
#echo "$s_mark"
	rank=`FindRank $sorted_batch_marks $s_mark`
echo "$rank"	
	rank3=$rank
echo "Rank3 is $rank3"
	batch_marks4=`sed -n '2,$p' basic-refresher_marks.csv | cut -d',' -f11`
	unsorted_marks=$batch_marks4
	sorted_batch_marks=`Sort $unsorted_marks`
	s_mark=$mark4
#echo "$s_mark"
	rank=`FindRank $sorted_batch_marks $s_mark`
echo "$rank"
	rank4=$rank
echo "Rank4 is $rank4"
	batch_marks5=`sed -n '2,$p' basic-refresher_marks.csv | cut -d',' -f12`
	unsorted_marks=$batch_marks5
	sorted_batch_marks=`Sort $unsorted_marks`
	s_mark=$mark5
#echo "$s_mark"
	rank=`FindRank $sorted_batch_marks $s_mark`
echo "$rank"
	rank5=$rank
echo "Rank5 is $rank5"
#	batch_marks=`sed -n '2,$p' basic-refresher_marks.csv | cut -d',' -f13`
#	rank6=`FindRank $batch_marks $mark6`
#	echo "$rank6"

	echo "Subject Name,Marks,Rank" > "$name".csv
	echo "Emertxe scholarship test : Programming in C,$mark1,$rank1" >> "$name".csv
	echo "Emertxe scholarship test : Computer Science,$mark2,$rank2" >> "$name".csv
	echo "C Programming,$mark3,$rank3" >> "$name".csv
	echo "Emertxe scholarship test : Analytical ability,$mark4,$rank4" >> "$name".csv
	echo "Aptitude,$mark5,$rank5" >> "$name".csv	
done

##############################generate test wise batch report###########################
for((column=8; column<=13; column++))
do
	subject_name=`cut -d',' -f$column basic-refresher_marks.csv | head -1`
	echo "$subject_name"
	unsorted_marks=`cut -d',' -f$column basic-refresher_marks.csv | sed -n '2,$p'`
	sorted_marks=`Sort $unsorted_marks`
	j=0
	for i in $sorted_marks
	do
		sorted_arr[$j]=$i
		let j=$j+1
	done
	echo "${sorted_arr[@]}"
	cut -d',' -f1,$column basic-refresher_marks.csv > temp
	head -1 temp > "$subject_name".csv
	count=0
	for((i=0; i<=${#sorted_arr[@]}-1; i++))
	do
		if [[ "$i" -gt 0 ]]
		then
			for((j=0; j<$i; j++))
			do
				match=`echo "${sorted_arr[$i]} == ${sorted_arr[$j]}" | bc`
				if [[ $match -eq 1 ]]
				then
					let count=$count+1
					break
				fi
			done
			if [[ $count -eq 0 ]]; then
				echo "appended"
				grep "${sorted_arr[$i]}" temp >> "$subject_name".csv
			fi
		else
			echo "appended"
			grep "${sorted_arr[$i]}" temp >> "$subject_name".csv
		fi
	done
done


