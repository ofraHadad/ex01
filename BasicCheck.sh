#!/bin/bash

dir_path=$1
makeArgu=$2
program=a.out
com=PASS
mem=PASS
thread=PASS
result=0
curentLocation='pwd'
touch temp

cd $dir_path

make MAIN=$makeArgu > null
if [ $? -eq 0 ]; then
    result=0
else
    com=FAIL
    result=4
    echo compilation FAIL 
    rm temp
    cd $corentLocation
    exit #$result
fi

valgrind --tool=helgrind --error-exitcode=1 --log-file=temp  ./$program shift 2 $@ > null
if [ $? -eq 1 ]; then
   
    thread=FAIL
    result=$((result+1))
   
fi
valgrind --leak-check=full --error-exitcode=2 --log-file=temp  ./$program shift 2 $@ > null

if [ $? -eq 2 ]; then
     mem=FAIL
     result=$((result+2))
     
fi

echo -e "BasicCheck.sh" "$dir_path $makeArgu\n    Compilation    Memory leaks    thread race \n \t$com \t\t $mem \t\t$thread"
rm temp
cd $corentlocation
exit #$result
