#!/bin/bash

#Mauricio Vinagre 
#This script grades the file gettysburg.sh

if [ $# -lt 1 ]; then
	echo "Usage: ./gradeit.sh MAXPOINTS"
	exit 1
fi

echo "Retro Grade-It, 1970s version"
echo "Grading with a max score of $1"
echo " "

cd students
for var in `ls`; do
	echo "Processing $var ..."
	cd "$var"
	bash ./gettysburg.sh 2>/dev/null >temporaryFile.txt
	if [ $? -ne 0 ]; then
		echo "$var did not turn in the assignment"
		echo "$var has earned a score of 0 / $1"
	else

	#if [ $? -eq 0 ]; then
		numberofMatchingLines=`diff -w temporaryFile.txt ../../expected.txt |egrep -c "<|>"`
		if [ $numberofMatchingLines -eq 0 ]; then
			echo "$var has correct output"
		else
			echo "$var has incorrect output ($numberofMatchingLines lines do not match)"
		fi

		numberofCommentLines=`grep "#" gettysburg.sh | wc -l`
		echo "$var has $numberofCommentLines lines with comments"
		pointsOff=$(($numberofMatchingLines*5))
		
		if [ $numberofCommentLines -lt 3 ]; then
			pointsOff=$(($pointsOff+7))
		fi

		totalScore=$(($1-$pointsOff))
		if [ $totalScore -lt 0 ]; then
			totalScore=0
		fi
		echo "$var has earned a score of $totalScore / $1"
	
	fi
		

	rm temporaryFile.txt
	cd ..
	echo " "
done




