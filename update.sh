#!/bin/bash

git submodule init
git pull --recurse-submodules
git submodule update --recursive
git submodule status
