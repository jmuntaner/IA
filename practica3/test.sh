#!/bin/bash

CASOS=(basico 1 2 3 4)

for i in "${CASOS[@]}"
do
    Metric-FF/ff -o dominio_$i.pddl -f problema_$i.pddl > /dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR en $i"
        exit -1
    fi
    python3 generator.py $i 4 > test.pddl
    Metric-FF/ff -O -o dominio_$i.pddl -f test.pddl > /dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR en generador $i"
        exit -1
    fi
done

