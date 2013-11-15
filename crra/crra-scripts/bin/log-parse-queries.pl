#!/shared/perl/5.8.9/bin/perl

# log-parse-queries.pl - list all the queries sorted by frequency

# Eric Lease Morgan <emorgan@nd.edu>
# August 15, 2011 - first cut


# configure
use constant INPUT => '/shared/catholic_portal/tmp/queries.txt';

# require
use strict;
use URI::Escape;

# initialize
open QUERIES, ' < ' . INPUT or die "Can't open " . INPUT . ": $!\n";
my %queries = ();
my $count = 0;

# process every line
while ( <QUERIES> ) {

	chop;
	my $line =  uri_unescape( $_ );
	$line    =~ s/^.*\?//;
	my ( $lookfor, $garbage ) = split /&/, $line;
	$lookfor =~ s/lookfor=//;
	$lookfor =~ s/\+/ /g;
	$lookfor =~ s/ +/ /g;
	$lookfor =~ s/" /"/g;
	if ( ! $lookfor ) { $lookfor = 'null' }
	$queries{ $lookfor }++;
	$count++;
		
}

# echo
foreach ( sort { $queries{ $b } <=> $queries{ $a } } keys %queries ) { print $queries{ $_ }, "\t$_\n" }

