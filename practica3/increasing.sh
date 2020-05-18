#!/bin/bash

i=1
python3 generator.py 2 $i > test.pddl
lines=$(wc -l test.pddl | awk '{print $1}')
while [ $i -le 29 ]
do
    j=0
    tt=0
    while [ $j -lt 5 ]
    do
        lines=10000
        while [ ${lines} -ge 195 ]
        do
            python3 generator.py 2 $i > test.pddl
            lines=$(wc -l test.pddl | awk '{print $1}')
        done
        t=$({ TIMEFORMAT=%U; time Metric-FF/ff -O -o dominio_2.pddl -f test.pddl > /dev/null; } 2>&1 )
        t=$(echo $t | sed -e 's/,/./g')
        tt=$(dc -e "4 k $tt $t + p")
        j=$((j+1))
    done
    tt=$(dc -e "4 k $tt $j / p")
    echo "$i $tt"
    i=$((i+1))
    
done
