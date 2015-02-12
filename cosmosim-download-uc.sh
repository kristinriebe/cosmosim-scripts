#!/bin/bash
#
# Download results as csv-files for jobids read from given file 
#
# Needs uws-client: 
#     https://github.com/adrpar/uws-client/
# Documentation on CosmoSim's UWS interface: 
#     http://www.cosmosim.org/cms/documentation/data-access/access-via-uws/
#
# 
# Usage: bash cosmosim-download-uc.sh idfile
# 
# NOTE: There is no error handling here, the script will break, 
# if there are no results for the jobs!
#
# Author: Kristin Riebe, AIP, November 2014

if [ $# -lt 1 ]
then
    echo "Please provide a filename with jobids as command line argument, e.g.:"
    echo "    bash cosmosim-download.sh jobids.txt"
    exit
fi


username='xxusernamexx'
password='xxpasswordxx'
uws="./uws"

url='http://www.cosmosim.org/uws/query'

idfile=$1

# read file with jobids
declare -a jobidlist
jobidlist=(`less $idfile`)
numid=${#jobidlist[*]} 

# If all jobs have completed, you can retrieve the results:
echo "Trying to retrieve the results. There is no proper error handling included here, so it may break easily in case of trouble."
# get result-urls and download to files
for (( i=0; i<$numid; i++ ))
do
   jobid=${jobidlist[$i]}
   echo 
   echo "Result for job $jobid ..."

   cmd="$uws --host ${url} --user ${username} --password ${password} job results $jobid csv"
   $cmd
   
done

exit
