#!/usr/bin/env bash
# ./autorun "<testcase> <testcase>" <IP> <times>
# EX: ./autorun xxx 74 3 &

# folder name by date
date=`date +%Y%m%d-%H%M`
mkdir $date
cd $date

echo "Testing Started" >> result.txt
echo "" >> result.txt

Red='\033[0;31m'
FlRed='\033[5;31m'
Green='\033[0;32m'
Purple='\033[0;35m'
NC='\033[0m'

for test in $1
do
	echo -e "Running ${Purple}$test${NC}" >> result.txt
	mkdir $test

	TT=0
	TF=0
	TP=0

	for (( counter=1; counter<$3+1; counter++))	
	do
		echo -n "Round $counter" >> result.txt
		#command to run test

		P=$(grep -c "\[ PASS \]" $test/LastRun$test.txt)
		F=$(grep -c "\[ FAIL \]" $test/LastRun$test.txt)
	
	if [ $F -gt 0 ]
	then
		echo -e "   [${Red}FAIL${NC}]" >> result.txt
		cat $test/LastRun$test.txt >> $test/FailedTests$test.txt
		grep "\[ FAIL \]" $test/LastRun$test.txt >> $test/FailedErrors$test.txt
	fi
	
	if [ $P -gt 0 ]
	then
		echo -e "   [${Green}PASS${NC}]" >> result.txt
		cat $test/LastRun$test.txt >> $test/PassTests$test.txt
	fi	
	TF=$((TF+F))
	TP=$((TP+P))
	TT=$((TT+1))
 
	#counter loop
	done
	echo ""

	#DUTs end up dead after a long run, 
	#Taking a break inbetween.
	if [ $counter -gt 10 ]
	then
		sleep 10
	fi
	
	passRate=`expr $TP / $TT \* 100`
	echo -e "Total runs = $TT, $TF Failed, $TP Passed, Passing rate: ${FlRed}$passRate${NC} %" >> result.txt
	echo "" >> result.txt
done #test loop
