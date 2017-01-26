#!/bin/bash

#Anthony Courchesne, January 2017


#Shell script to compile, run a java program with the sample.in file
#as standard input and compare the output to sample.ans.

#TODO check samples files exists
usage () {
    echo 'usage:'
    echo 'tester.sh filename [OPTIONS]'
    echo ' '
    echo 'OPTIONS:'
    echo ' -i | --input filename'
    echo '      Specifies the file used as input'
    echo '      Default is sample.in'
    echo ' -a | --answer filename'
    echo '      Specifies the file to compare answer'
    echo '      Default is sample.ans'
}


if [ "$#" -eq 0 ]; then
    echo 'ERROR: no arg specified'
    usage
    exit 1
fi
filename=$1
input="sample.in"
answer="sample.ans"
shift
if [[ $filename = *.java ]]; then
    filename=${filename:0:-5}
fi

while [ "$1" != "" ]; do
    case $1 in
        -i | --input)   shift
                        input=$1
                        ;;
        -a | --answer)  shift
                        answer=$1
                        ;;
        -h | --help)    usage
                        exit
                        ;;
        * )             usage
                        exit 1

    esac
    shift
done



javac $filename.java

ret=$?
if [ $ret -ne 0 ]; then
    exit $?
fi

OUTPUT=$(diff $answer <(cat $input | java $filename))

if [ -z "$OUTPUT" ]; then
    echo 'Test completed succesfully'
else
    echo $OUTPUT
fi


#If nothing output, display CORRECT
#Else, display diff output
