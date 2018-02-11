#!/bin/bash

find ../../../ -name '*.hpp' |xargs tar czf t1.tgz
find ../../../ -name '*.h' |xargs tar czf t2.tgz

rm -f -R ../../../../../include/SSDK/*

tar xzvf t1.tgz -C ../../../../../include/SSDK
tar xzvf t2.tgz -C ../../../../../include/SSDK

rm -f t1.tgz 
rm -f t2.tgz 

cp -rf *.so* ../../../../../lib/release
