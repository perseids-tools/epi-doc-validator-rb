#!/bin/bash

rm -r vendor/schema
wget --no-parent -nH --cut-dirs 1 -r -A .rng,'LICENSE*' -P ./vendor/schema 'http://epidoc.stoa.org/schema/'
rm ./vendor/schema/robots.txt.tmp
