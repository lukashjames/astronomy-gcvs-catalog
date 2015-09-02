Description
===========

This package contains General Catalogue of Variable stars (GCVS, [VizieR B/gcvs](http://cdsarc.u-strasbg.fr/viz-bin/Cat?B/gcvs)) in SQL format (MySQL/MariaDB). Also package contains simple Perl to import data from text catalogue.

Catalogue info
--------------

**B/gcvs** General Catalogue of Variable Stars (Samus+ 2007-2013), version 2013-04-30

General Catalog of Variable Stars (GCVS database)

Samus N.N., Durlevich O.V., et al.

Institute of Astronomy of Russian Academy of Sciences and Sternberg State Astronomical Institute of the Moscow State University

Requirements:
-------------

If you want your own import with Perl script, you need file gcvs_cat.dat.gz from B/gcvs ([direct link](http://cdsarc.u-strasbg.fr/vizier/ftp/cats/B/gcvs/gcvs_cat.dat.gz)).

Perl script requirements:

* PerlIO::gzip
* DBI
* Getopt::Long
* Term::ReadPassword
* FindBin
    
Usage
-----

If you want use SQL GCVS from this package you need use this command:

    $ bzip2 -cd gcvs_cat.sql.bz2 | mysql -uusername -p gcvs

*Note* Do not forget create database 'gcvs' before execution this command.

Using Perl script (from console):

    $ ./gcvs2sql.pl [[--dbhost=db.myserver.org] --dbuser=username [--dbpasswd] --dbname=databasename [--quiet]]

Options:
--------

List of options:

* --dbhost Database host (default - localhost)
* --dbuser Username for database (required option)
* --dbpass Database password will be prompted (default - empty password)
* --dbname Database name (required option)
* --quiet  Do not print anything (quiet mode)

Examples:
---------

**Example 1.** Without any option:

    $ ./gcvs2sql.pl

Output:

> Usage: ./gcvs2sql.pl [[--dbhost=db.myserver.org] --dbuser=username [--dbpasswd] --dbname=databasename [--quiet]]

> --dbhost Database host (default - localhost)

> --dbuser Username for database (required option)

> --dbpass Database password will be prompted (default - empty password)

> --dbname Database name (required option)

> --quiet  Do not print anything (quiet mode)

**Example 2.** Connecting to localhost with empty password (ATTENTION!!! Using empty password is not recommended by security reasons).

    $ ./gcvs2sql.pl --dbuser=username --dbname=databasename

**Example 3.** Connecting to host db.myserver.org] with password. Password will be prompted from STDIN without echoing (form like --dbpass=mypassword not supported, 'mypassword' will be ignored).

    $ ./gcvs2sql.pl --dbhost=db.myserver.org --dbuser=james --dbpasswd --dbname=gcvs

**Example 4.** Using quiet mode (do not print anything)

    $ ./gcvs2sql.pl --dbhost=db.myserver.org --dbuser=jane --dbpasswd --dbname=gcvs --quiet

