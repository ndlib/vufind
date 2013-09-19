# subroutines.pl - common tasks for "Catholic Portal" pre-processing

# Eric Lease Morgan <emorgan@nd.edu>
# October   8, 2010 - first documentation
# April    30, 2012 - added address to read_institutions
# December 20, 2012 - gets input from @ARGV and selects institutions


# read a tab delimited file and return it as a reference to a hash
sub read_institutions {

	# initialize
	my $file          = shift;
	my $abbreviations = shift;	
	my %r             = ();	
	
	# process the input
	open INPUT, " < $file" or die "Can't open $file: $!\n";
	while ( <INPUT> ) {
	
		# parse
		chop;
		next if ( length( $_ ) < 1 ); # empty 
		next if ( $_ =~ /^ / );       # blank
		next if ( $_ =~ /^#/ );       # comments
		last if ( $_ =~ /^=/ );       # "cut", a la Perl
		my ( $key, $institution, $library, $marc, $ead, $address ) = split /\t/, $_;
		
		# check abbreviations against input; first, no input
		if ( $$abbreviations[ 0 ] eq '' ) { print "$key\t$institution ($library)\n" }
		
		# check for selected library abbreviation
		elsif ( grep { $_ eq $key } @$abbreviations ) { $r{ $key } = [ ( $institution, $library, $marc, $ead, $address ) ] } 

		# special input 'all'
		elsif ( $$abbreviations[ 0 ] eq 'all' ) { $r{ $key } = [ ( $institution, $library, $marc, $ead, $address ) ] }
		
	}
	close INPUT;

	# done
	return \%r;

}


# read a file
sub slurp {

	# open a file named by the input and return its contents
	my $f = shift;
	my $r;
	open F, $f or die "Can't slurp: $!\n";
	$r = do { local $/; <F> };
	return $r;

}


sub escape_entities {

	# get the input
	my $s = shift;
	
	# escape
	$s =~ s/&/&amp;/g;
	$s =~ s/</&lt;/g;
	$s =~ s/>/&gt;/g;
	$s =~ s/"/&quot;/g;
	$s =~ s/'/&apos;/g;

	# done
	return $s;
	
}


1; # return true or die
