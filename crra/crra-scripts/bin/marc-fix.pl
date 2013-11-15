#!/usr/bin/perl

# fix.pl - change/update postion #9 of all MARC records from STDIN to equal "a"

# Eric Lease Morgan <emorgan@nd.edu>
# March 28, 2013 - first investigations; \035 is the MARC record terminator


# require
use strict;

# initialize
binmode STDIN,  ":bytes";
binmode STDOUT, ":bytes";
$/ = "\035"; 

# loop through the input
while ( <> ) {

	# do the work and output
	substr( $_, 9, 1 ) = "a";
	print $_;
	    
}

# done
exit;
