#!/bin/bash
md5sum ${1} | md5sum -c ${2}
