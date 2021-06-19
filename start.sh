#!/bin/sh

docker run -it --rm -v `pwd`:/code --platform linux/386 $(docker build -q .) $*
