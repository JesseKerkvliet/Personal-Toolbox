#!/bin/bash
for filename in $(ls *.tar.gz); do
tar xzf $filename
done
