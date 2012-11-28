#!/bin/sh
exit_usage()
{
	echo "$0 [-l] [-d delay] [-c count] -o result_dir"
	exit 1
}

DELAY=1
while getopts "ld:c:o:" arg
do
	case $arg in
		l)
			export LD_PRELOAD=./lockmem.so
			;;
		d)
			DELAY=$OPTARG
			;;
		c)
			COUNT=$OPTARG
			;;
		o)
			DIR=$OPTARG
			;;
	esac
done

[ ! $DIR ] && exit_usage
[ ! -d $DIR ] && exit_usage

DIR=$DIR/`date "+%Y%m%d-%H%M%S"`
mkdir $DIR

vmstat $DELAY $COUNT > $DIR/vmstat & vmstat_pid=$!
iostat -x $DELAY $COUNT > $DIR/iostat & iostat_pid=$!
./getprocinfo meminfo $DELAY $COUNT > $DIR/procmeminfo & meminfo_pid=$!
./getprocinfo vmstat $DELAY $COUNT > $DIR/procvmstat & procvmstat_pid=$!
./getprocinfo zoneinfo $DELAY $COUNT > $DIR/proczoneinfo & zoneinfo_pid=$!

handle_trap()
{
	kill $vmstat_pid
	kill $iostat_pid
	kill $meminfo_pid
	kill $procvmstat_pid
	kill $zoneinfo_pid
}
trap handle_trap INT
wait
unset LD_PRELOAD
