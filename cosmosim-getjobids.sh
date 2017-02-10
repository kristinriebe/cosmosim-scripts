#!/bin/bash
#
# Extract jobids for given job/table names.
#
# Usage: bash cosmosim-multiqueries.sh namepattern
#
# Needs httpie: 
#     https://github.com/jkbr/httpie
# Documentation on CosmoSim's UWS interface: 
#     https://www.cosmosim.org/cms/documentation/data-access/access-via-uws/
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

url='https://www.cosmosim.org/uws/query'

namepattern=$1
idfile=$2

# first get complete joblist, i.e. job name, jobid and status
cmd="http --auth ${username}:${password} --print b GET $url"
echo "$cmd" 
joblist=`$cmd | \
        awk '{if ($1 ~ /:jobref/ && $1 !~ /<\//) {\
                        jobname = $0;\
                  			gsub(/.* runId="/,"",jobname);\
                        gsub(/".*/,"",jobname);\
                        jobid = $0;\
                  			gsub(/.* id="/,"",jobid); gsub(/".*/,"",jobid);\
                  }\
                  if ($1 ~ /:phase/) {\
                    phase = $0;\
                    gsub(/<\/.*/,"",phase);\
                    gsub(/.*:phase>/,"",phase);\
                    print jobid, jobname, phase \
                  } \
                 }'`


# now filter by namepattern
echo "Jobs matching the given pattern (jobid, jobname, status): "

# -- print to terminal only
echo "joblist: $joblist"
#echo "$joblist" | awk '{if ($2 ~ /'$namepattern'/) {print $0;}}'		 

# -- also print ids to given file 
rm -rf $idfile 
touch $idfile
echo "$joblist" | awk '{if ($2 ~ /'$namepattern'/) {print $0; printf "%d\n", $1 >> "'$idfile'"}}'
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

