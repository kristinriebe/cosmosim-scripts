#!/bin/bash
#
# Remove own jobs from CosmoSim, based on jobids in given file.
# If you don't have the jobids, get a list of all jobs by running
#    http --auth $username:$password --print b GET http://www.cosmosim.org/uws/query
# Also consider using the uws-client (https://github.com/adrpar/uws-client) for this. 
# The astroquery.cosmosim-package (https://github.com/agroener/astroquery) also has nice 
# features for deleting.
#
# Note: if running jobs get a 'delete' signal, they will only be stopped.
#
# Needs httpie: 
#     https://github.com/jkbr/httpie
# Documentation on CosmoSim's UWS interface: 
#     https://www.cosmosim.org/cms/documentation/data-access/access-via-uws/
# 
# Author: Kristin Riebe, AIP, November 2014

if [ $# -lt 1 ]
then
    echo "Please provide a filename with jobids as command line argument, e.g.:"
    echo "    bash cosmosim-deletejobs.sh jobids.txt"
    exit
fi


username='xxxxxx'
password='xxxxxx'

url='https://www.cosmosim.org/uws/query'

idfile=$1

# read file with jobids
declare -a jobidlist
jobidlist=(`less $idfile`)
numid=${#jobidlist[*]} 

# If all jobs have completed, you can retrieve the results:
echo "Trying to delete the jobs. There is no error handling included here, so it may break."
# get result-urls and download to files
for (( i=0; i<$numid; i++ ))
do
   cmd="http --auth ${username}:${password} --follow DELETE ${url}/${jobidlist[$i]}"
   results=`$cmd`
done

