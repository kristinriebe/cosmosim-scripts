#!/bin/bash
#
# Download results as csv-files for jobids read from given file 
#
# Needs httpie: 
#     https://github.com/jkbr/httpie
# Documentation on CosmoSim's UWS interface: 
#     http://www.cosmosim.org/cms/documentation/data-access/access-via-uws/
#
# 
# Usage: bash cosmosim-download.sh idfile
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

url='https://www.cosmosim.org/uws/query'

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
   echo 
   echo "Result for job ${jobidlist[$i]} ..."

   cmd="http --auth ${username}:${password} GET ${url}/${jobidlist[$i]}/results"
   results=`$cmd`

   resulturl=`echo $results | grep csv | sed -e '' -e 's/\/csv\".*/\/csv\//g' | sed -e 's/.*xlink:href=\"//'`
   
   if [ -z $resulturl ]
   then
       echo "Sorry, no result-url found. Please check the job's status manually."
       echo "Use e.g. http --auth ${username}:${password} GET ${url}/${jobidlist[$i]}/phase/"
   else
       echo "Retrieve results for job $i (jobid ${jobidlist[$i]}) using following url: $resulturl"
       http --auth ${username}:${password} --print b --download GET $resulturl
   fi
done

exit
