#!/usr/bin/perl

# validate.pl - check for non-UTF-8 characters in a file of MARC records

# Eric Lease Morgan <emorgan@nd.edu>
# March 28, 2013 - really a program by Galen Charlton <gmcharlt@gmail.com>


# require
use strict;
use Encode;

# initialize
binmode STDIN, ":bytes";
$/    = "\035";  # MARC record terminator
my $i = 0;

# read STDIN
while ( <> ) {

    # increment
    $i++;
    
    # check validity
    eval { my $utf8str = &Encode::is_utf8( $_, Encode::FB_CROAK ); };
    
    # check for error
    if ( $@ ) { print "Record $i contains non-UTF-8 characters\n"; }
    
}

# done
exit;
