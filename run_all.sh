#!/bin/bash
set -e

IN="/COV_OUT"
OUT="/COV_RESULTS"

if [ ! -d "$IN" ]; then
    echo "Missing /COV_OUT mount"
    exit 1
fi

mkdir -p "$OUT"

for d in "$IN"/*; do
    [ -d "$d" ] || continue
    base=$(basename "$d")
    outf="$OUT/$base"
    echo "base=${base} outf=${outf}"
    mkdir -p "$outf"

    for r in "$d"/*; do
	    run=$(basename $r)
	    outrun=$outf/$run
	    echo "run=${run} outrun=${outrun}"
	    mkdir -p "$outrun"

	    python3 /usr/local/bin/afl_cov_graph.py \
		"$r" \
		--metric edges \
		--png "$outrun/coverage.png" \
		--csv "$outrun/coverage.csv"
    done
done
