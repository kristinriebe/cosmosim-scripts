#!/bin/bash
#
# Remove own jobs from CosmoSim, based on jobids in given file.
# If you don't have the jobids, get a list of all jobs by running
#    uws --host www.cosmosim.org/uws/query --user <username> --password <password> list
# You could also use the astroquery.cosmosim-package (https://github.com/agroener/astroquery), 
# which has nice features for deleting.
#
# Note: if running jobs get a 'delete' signal, they will only be stopped.
#
# Needs uws-client: 
#     https://github.com/adrpar/uws-client/
# Documentation on CosmoSim's UWS interface: 
#     http://www.cosmosim.org/cms/documentation/data-access/access-via-uws/
#
# Usage: bash cosmosim-download-uc.sh idfile
# 
# Author: Kristin Riebe, AIP, November 2014

if [ $# -lt 1 ]
then
    echo "Please provide a filename with jobids as command line argument, e.g.:"
    echo "    bash cosmosim-deletejobs-uc.sh jobids.txt"
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
echo "Trying to delete the jobs. There is no error handling included here, so it may break."
# get result-urls and download to files
for (( i=0; i<$numid; i++ ))
do
   jobid=${jobidlist[$i]}
   echo "Deleting job $jobid ..."
   cmd="$uws --host ${url} --user ${username} --password ${password} job delete $jobid"
   $cmd
done

