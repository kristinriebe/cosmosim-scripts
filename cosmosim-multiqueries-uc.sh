#!/bin/bash
#
# Send multiple queries to CosmoSim.org; store jobids in file jobids.txt.
#
# Needs uws-client: 
#     https://github.com/adrpar/uws-client/
# Documentation on CosmoSim's UWS interface: 
#     http://www.cosmosim.org/cms/documentation/data-access/access-via-uws/
# 
# Usage: bash cosmosim-multiqueries-uc.sh idfile
#
# This script splits the following query:
#
#     select bdmId,x,y,z,np,hostFlag,Mvir,Rvir from MDR1..BDMV where snapnum = 85
#
# into smaller queries which are executed in a loop.
# Please add your own username and password below.
#
# You would also want to adjust the query itself, as well as the "limit"-statement in the query, $numjobs and $tablebase for the tablename.
#
# Note: This script does NOT check for any kind of errors! 
# It is meant mainly for demonstration purposes, please consider using a proper client
# like https://github.com/adrpar/uws-client for your science queries.
#
#
# Author: Kristin Riebe, AIP, November 2014

if [ $# -lt 1 ]
then
    echo "Please provide a filename for the job-ids as command line argument, e.g.:"
    echo "    bash cosmosim-multiqueries.sh jobids.txt"
    exit
fi


username='xxusernamexx'
password='xxpasswordxx'
uws="./uws"

url='https://www.cosmosim.org/uws/query'

idfile=$1

queue="long"	# long or short 
snapnum=85		# snapshot number

tablebase='bdm85-manyyuc2'	# basename for result tables, please adjust!
numjobs=2		# number of jobs, please adjust!

declare -a jobidlist

for (( i=0; i<$numjobs; i++ ))
do
    # bdmId ranges from $snapnum * 1e8 + original id in file  
    start=$i
    end=$(($i+1))
   
    query="select bdmId,x,y,z,np,hostFlag,Mvir,Rvir from MDR1.BDMV where bdmId between ${snapnum} * 1e8 + $start*1e5 and ${snapnum} * 1e8 + $end*1e5 - 1 and snapnum = ${snapnum}"

    # Everything below this point usually does not need to be adjusted.
    # You only need to adjust the query, tablebase, parameters, numjobs, 
    # username and password above.

    tablename="${tablebase}-$i"
    echo "query: $query"

    # submit job to server, get a jobid
    cmd="$uws --host ${url} --user ${username} --password ${password} job new query=\"${query}\" table=\"${tablename}\" queue=\"${queue}\""
    job=`$uws --host ${url} --user ${username} --password ${password} job new query="${query}" table="${tablename}" queue="${queue}"`
    
    job2=`echo "$job" | sed -e 's/\ //g'`
    #echo "job: '$job'"
    if [[ -z "$job2" ]] 
    then
        echo "There was nothing returned. Please check the host url, username and password."
        echo "Maybe run a test first using following command:"
        echo "$cmd"
        exit
    fi

    jobid=`echo "$job" | grep "Job ID" | awk '{print $3}'`

    echo "jobId, tablename: $jobid, $tablename"
   
    # start job
    start=`$uws --host ${url} --user ${username} --password ${password} job run ${jobid}`

    # store jobid in array:
    jobidlist[$i]="$jobid"
   
    # sleep a bit before starting the next one in order to avoid server-troubles
    sleep 1

done


echo "All jobs have been submitted. Their jobids are:"
rm -rf $idfile
touch $idfile
for (( i=0; i<$numjobs; i++ ))
do
    jobid=${jobidlist[$i]}
    echo "$jobid"
    echo $jobid >> $idfile
done
echo "These are also written to $idfile."
echo "Check the job status e.g. with" 
echo "    $uws --host ${url} --user ${username} --password ${password} job show ${jobid}"
echo "Once the jobs are completed, you can download them using the results-url."
echo "This can also be done automatically using the cosmosim-download-uc.sh script:"
echo "    bash cosmosim-download-uc.sh $idfile"

exit
