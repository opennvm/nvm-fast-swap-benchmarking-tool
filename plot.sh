#!/bin/bash

exit_usage()
{
	echo "$0 result_dir"
	exit 1
}

[ ! $1 ] && exit_usage
[ ! -d $1 ] && exit_usage

file=`mktemp`
cat $1/vmstat| grep -v -E 'si|swap'| \
awk '{printf("%d %d %d\n", $3, $7,$8)}' \
> $file

gnuplot-nox <<EOF
set terminal png size 1680,1024 font '/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf,14'

set autoscale
set grid

set output "$1/vmstat.png"

set xlabel "Runtime(S)"
set ylabel "Memory(KB)"
set multiplot

set title "swaped memory"
set size 1,0.3
set origin 0.0,0.7

plot "$file" using 1 title "swapd" with lines

set size 1,0.7
set origin 0.0,0.0

set title "swap throughput"
set ylabel "Throughput(KB/s)"

plot "$file" using 2 title "SwapIN" with lines, "$file" using 3 title "SwapOUT" with lines

unset multiplot

EOF

rm -f $file
