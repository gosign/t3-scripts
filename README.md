# t3-scripts
This repository contains some utility scripts which tend to be useful when working with
the TYPO3 CMS system. 


## mv_t3plugin.rb
This script can be used to rename a plugin created by the kickstarter extension. **You
should only use it with freshly created plugins, it hasn't been tested with anything
else**.


## t3-mysqldump
TYPO3 and common extension have lots of caching tables that do not need to be
dumped when creating a database dump. This script generates a mysqldump command
that ignores common cache tables.
