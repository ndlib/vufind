#!/usr/bin/perl

# directory.pl - create a list of libraries for the "portal"

# Eric Lease Morgan <emorgan@nd.edu>
# April    30, 2012 - first cut
# February 18, 2013 - configured for cportal; updated read_institutions to take additional input


# define
use constant DB   => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant HTML => '/opt/vufind/crra/data/html/data/directory.html';

# include
use CGI;
use strict;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initialize
my $libraries = &read_institutions( DB, [ @ARGV ] );
my $cgi       = CGI->new;
my $directory = '';

# process each entry
foreach my $key ( sort keys %$libraries ) {

	# get
	my $library = $$libraries{ $key }->[ 1 ];
	my $address = $$libraries{ $key }->[ 4 ];

	# munge
	$address =~ s/\|/<\/br>/g;
	$address = $cgi->p( $address );
	print "$address\n";

	# update the directory
	$directory .= $cgi->a({ name => $key }, $address );
	
}

# output
my $html =  &template;
$html    =~ s/##CONTENT##/$directory/e;
open OUTPUT, ' > ' . HTML or die "Can't open " . HTML . ": $!\n";
print OUTPUT $html;
close OUTPUT;

# done
exit;


sub template {

	return <<EOT
<html>
<head>
<title>CRRA directory</title>
</head>
<body style='margin: 5%'>
<h1>CRRA directory</h1>
<p>This is a list of all the institutions providing content via the "Catholic Portal". Please send corrections and additions to <a href='mailto:emorgan\@nd.edu?subject=crra%20directory'>Eric Lease Morgan</a>.</p>
##CONTENT##
</body>
</html>
EOT

}
