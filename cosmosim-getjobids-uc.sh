#!/bin/bash
#
# Extract jobids for given job/table names.
#
# Usage: bash cosmosim-multiqueries.sh namepattern
#
# Needs uws-client: 
#     https://github.com/adrpar/uws-client/
# Documentation on CosmoSim's UWS interface: 
#     http://www.cosmosim.org/cms/documentation/data-access/access-via-uws/
# 
# Author: Kristin Riebe, AIP, November 2014

if [ $# -lt 2 ]
then
    echo "Please provide a pattern for tablenames and an id-file for writing."
    echo "Use awk-regular expressions, e.g."
    echo "^ for start, $ for end of expression, . for any character, * for repeating."
    echo "Examples:"
    echo "    bash cosmosim-getjobids.sh bdm85  idfile.txt  # match any jobname containing bdm85"
    echo "    bash cosmosim-getjobids.sh ^bdm85-many-1$  idfile.txt   # match exactly given name"
    exit
fi

username='xxusernamexx'
password='xxpasswordxx'
uws="./uws"

url='https://www.cosmosim.org/uws/query'

namepattern=$1
idfile=$2

# first get complete joblist, i.e. job name, jobid and status, then filter by namepattern
cmd="$uws --host $url --user $username --password $password list"
#echo "$cmd"
joblist=`$cmd | awk '/^[^=L ]/{ if ($2 ~ /'$namepattern'/) {print $0;}}'`
echo "Jobs matching the given pattern (jobname, jobid, status): "

# -- print to terminal only
#echo "$joblist"

# -- also print ids to given file 
rm -rf $idfile 
touch $idfile
echo "$joblist" | awk '{print $0; printf "%d\n", $1 >> "'$idfile'"}'
if [ ! -s $idfile ] 
then
    echo "Sorry, no jobnames matched the given pattern '$namepattern'."
	rm $idfile
else
    num=`wc -l $idfile | awk '{print $1;}'`
    echo "$num matching jobs found. Jobids were written to file $idfile."
fi

# or filter by status:
#status="COMPLETED"
#echo "$joblist" | awk '{if ($3 ~ /'$status'/) {print $0;}}'		 
#

exit

