#!/usr/bin/python2.7

import csv
import sys

inFile = sys.argv[1]
outFile = sys.argv[2]

with open(inFile) as fin:
    rows = csv.reader(fin, delimiter='\t', skipinitialspace=True)
    transposed = zip(*rows)
    with open(outFile, 'w') as fout:
        w = csv.writer(fout, delimiter='\t')
        w.writerows(transposed)