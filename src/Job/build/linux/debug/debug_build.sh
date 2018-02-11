#!/bin/bash

find ../../../ -name '*.hpp' |xargs tar czf t1.tgz
find ../../../ -name '*.h' |xargs tar czf t2.tgz

rm -f -R ../../../../../include/Job/*

tar xzvf t1.tgz -C ../../../../../include/Job
tar xzvf t2.tgz -C ../../../../../include/Job

rm -f t1.tgz 
rm -f t2.tgz 

cp -rf *.so* ../../../../../lib/debug
