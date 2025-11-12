#!/bin/sh

arm-linux-gnueabi-as $1 -o tmp.o

if [ $? -eq 0 ]; then
    echo "Assembly SUCCESS"
else
    echo "Assembly FAILED"
    exit 1
fi

arm-linux-gnueabi-gcc-13 tmp.o -o $2 -nostdlib

if [ $? -eq 0 ]; then
    echo "Linking SUCCESS"
else
    echo "Linking FAILED"
    exit 1
fi
