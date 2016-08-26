#!/usr/bin/perl

# harvest-ead.pl - copy remote EAD files locally; mirror them

# Eric Lease Morgan <emorgan@nd.edu>
# October   6, 2010 - first investigations; based on harvest.pl
# March     9, 2011 - configuring for james
# April     6, 2011 - removed relative paths from links
# December 20, 2012 - added command line input

# configure
use constant AGENT  => 'EADGetter';
use constant DB     => '/opt/vufind/crra/crra-scripts/etc/libraries.db';
use constant CACHE  =>  '/opt/vufind/crra/data/ead-incoming/' ;

# require
use HTML::SimpleLinkExtor;
use HTML::LinkExtor;
use LWP::UserAgent;
use strict;
require '/opt/vufind/crra/crra-scripts/lib/subroutines.pl';

# initilize
my $libraries = &read_institutions( DB, [ @ARGV ] );
my $ua        = LWP::UserAgent->new( agent => AGENT );

# process each library
foreach my $key ( sort keys %$libraries ) {
	
	# sanity check
	my $library = $$libraries{ $key }->[ 1 ];
	my $root    = $$libraries{ $key }->[ 3 ];
	next if ( ! $root );
	
	# get the root
	print "Getting $library...\n";
	my $extor = HTML::SimpleLinkExtor->new->parse_url( $root, $ua );
	
	# process all the found links
	foreach my $file ( sort $extor->links ) {

		# only want xml files
		next if ( $file !~ /xml$/ );
		
		# remove relative path, if it exists
		if ( $file =~ /\// ) {
		
			my @parts = split /\//, $file;
			$file = $parts[ $#parts ];
			
		}
		
		# build URL to get
		my $url = "$root$file";
		print "\t$url\n";
		
		my $response = $ua->get( $url );
		if ( ! $response->is_success ) {
		
			warn "Can't get $url: ", $response->status_line;
			next;
			
		}

		# save it
		my $directory = CACHE . "$key/";
		if ( ! -e $directory ) { mkdir $directory or die "Can't create $directory: $!\n" }
		open OUTPUT, " > $directory$file" or die "Can't open $directory$file: $!\n";
		print OUTPUT $response->content;
		close OUTPUT;

	}

}

# done
print "Done.\n";
exit;



