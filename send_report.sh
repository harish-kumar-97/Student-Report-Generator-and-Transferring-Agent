#!/bin/bash

read -p "Enter message body : " body
read -p "Enter Subject : " subject

mail_list=`cut -d',' -f2 basic-refresher_marks.csv | sed -n '2,$p'`
j=0
for i in $mail_list
do
	emails[$j]="$i"
	let j=$j+1
done

for((i=0; i<${#emails[@]}; i++)); do
	file_name=`grep "${emails[$i]}" basic-refresher_marks.csv | cut -d',' -f1`
	echo "Email sent Successfully to $file_name"
	echo "$subject\n$body"
	echo "$body" | mailx -s "$subject" -A "$file_name.csv" ${emails[$i]}
done
