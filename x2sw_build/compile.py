#!/usr/bin/python

import compileall

print "Compiling all the files in x2sw folder..."

compileall.compile_dir("../x2sw", force=1)
