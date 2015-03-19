
CosmoSim scripts
================

This is a collection of example-scripts for accessing the [CosmoSim database](http://www.cosmosim.org), which contains results 
from cosmological simulations, via the command line.
Since CosmoSim uses IVOA's [UWS](http://www.ivoa.net/documents/UWS/)-protocol for this, all the scripts 
can be adjusted to work with other databases with UWS-enabled web service (e.g. Millennium-TAP) as well.
Note that on CosmoSim you will need to [register](http://www.cosmosim.org/auth/registration/register) first (it's free!) to get an account.
See also [CosmoSim Blog](http://www.cosmosim.org/cms/news/shell-scripts-for-many-jobs/) and links therein for more information.

**Disclaimer**    
Please note that the shell scripts have no proper error handling and are quite basic. They are just examples for how to query the database and download results via scripts. I’ll be happy to help if things don’t work for you. But if you plan to run multiple queries on a regular basis, it’s probably better to put more efforts into using the [UWS-client](https://github.com/adrpar/uws-client/) or [astroquery.cosmosim](http://astroquery.readthedocs.org/en/latest/cosmosim/cosmosim.html) package for Python.

## Overview

Using `httpie`:  
* cosmosim-multiqueries.sh
* cosmosim-download.sh
* cosmosim-deletejobs.sh
* cosmosim-getjobids.sh

Using `uws-client` (see https://github.com/adrpar/uws-client/):
* cosmosim-multiqueries-uc.sh
* cosmosim-download-uc.sh
* cosmosim-deletejobs-uc.sh
* cosmosim-getjobids-uc.sh

The functionality of the `httpie` and `uws-client` versions is exactly the same. Within each script, the `username` and `password` variable must be set to your credentials.

**cosmosim-multiqueries**  
Usage: `bash cosmosim-multiqueries.sh file.txt`  
or `bash cosmosim-multiqueries-uc.sh file.txt`  

Sends multiple queries as specified within the script to the CosmoSim database
and stored the job id for each job in the provided file.

**cosmosim-download**  
Usage: `bash cosmosim-download.sh file.txt`  
or `bash cosmosim-download-uc.sh file.txt`  

Downloads the results as CSV-files for all job-ids given in the file. 
Only works if jobs are finished already successfully.

**cosmosim-deletejobs**  
Usage: `bash cosmosim-delete.sh file.txt`  
or `bash cosmosim-delete-uc.sh file.txt`  

Deletes jobs with job-ids in given file.

**cosmosim-getjobids**
Usage: `bash cosmosim-getjobids.sh pattern newfile.txt`  
or `bash cosmosim-getjobids-uc.sh pattern newfile.txt`  

Gets job-ids for all jobs with the jobname matching given pattern, e.g. 
'bdm-85-' etc. Uses `awk` regular expressions. The job-ids and status are
printed to screen, job-ids are also written to provided file.





## Examples



