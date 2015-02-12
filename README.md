
CosmoSim scripts
================

This is a collection of example-scripts for accessing the [CosmoSim database](http://www.cosmosim.org), which contains results 
from cosmoslogical simulations, via the command line.
Since CosmoSim uses IVOA's [UWS](http://www.ivoa.net/documents/UWS/)-protocol for this, all the scripts 
are in principle transferable to other UWS-enabled web services (e.g. Millennium-TAP) as well.
Note that on CosmoSim you will need to register first (it's free!) to get an account.

See [CosmoSim Blog](]http://www.cosmosim.org/cms/news/shell-scripts-for-many-jobs/) and links therein for more information.

**Disclaimer**
Please note that the shell scripts have no proper error handling and are quite basic. They are just examples for how to query the database and download results via scripts. I’ll be happy to help if things don’t work for you. But if you plan to run multiple queries on a regular basis, it’s probably better to put more efforts into using the [UWS-client](https://github.com/adrpar/uws-client/) or [astroquery.cosmosim](http://astroquery.readthedocs.org/en/latest/cosmosim/cosmosim.html) package for Python.

