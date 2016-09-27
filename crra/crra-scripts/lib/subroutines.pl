# subroutines.pl - common tasks for "Catholic Portal" pre-processing

# Eric Lease Morgan <emorgan@nd.edu>
# October   8, 2010 - first documentation
# April    30, 2012 - added address to read_institutions
# December 20, 2012 - gets input from @ARGV and selects institutions
# July      2, 2016 - added read and write database routines



sub db2table {

	return <<EOF;
<!DOCTYPE html>
<head>
	<title>##TITLE##</title>
  	<script type="text/javascript" charset="utf8" src="/data/etc/jquery-3.0.0.min.js"></script>
	<script type="text/javascript" charset="utf8" src="/data/etc/DataTables/datatables.js"></script>
	<link rel="stylesheet" type="text/css" href="/data/etc/DataTables/datatables.css">
    <script>
		\$(document).ready(function() {
			\$('#bibliographics').DataTable();
		} );
	</script>
</head>
<body>

<h1>##TITLE##</h1>

<table id="bibliographics" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
				<th>Key</th>
				<th>Title</th>
				<th>Author</th>
				<th>Edition</th>
				<th>Publication</th>
				<th>OCLC</th>
				<th>Total</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
				<th>Key</th>
				<th>Title</th>
				<th>Author</th>
				<th>Edition</th>
				<th>Publication</th>
				<th>OCLC</th>
				<th>Total</th>
            </tr>
        </tfoot>
		##TBODY##
    </table>
</body>
</html>
EOF
}


# slurp up the database; a poor man's database implementation
sub readDB {

	# Note: the output is a tab-delimited list with the following fields:
	#   key (MARC 001)
	#   title
	#   author
	#   edition
	#   publication
	#   oclc
	#   total
	#   symbols

	# initialize
	my %db    = ();
	my $file  = shift;
	my $index = 0;

	open FILE, "< $file" or die "Can't open DB ($file): $!. Call Eric\n";
	binmode( FILE, ":utf8");
	while ( <FILE> ) {

		# increment and skip the first line
		$index++;
		next if ( $index == 1 );

		# parse
		chop;
		my ( $key, $title, $author, $edition, $publication, $oclc, $total, $symbols ) = split "\t", $_;

		# update the database
		$db{ $key } = {
					   'title'       => $title,
					   'author'      => $author,
					   'edition'     => $edition,
					   'publication' => $publication,
					   'oclc'        => $oclc,
					   'total'       => $total,
					   'symbols'     => $symbols
					 };

 	}

	# done
	close FILE;
	return \%db;

}

# dump the contents of our "database" to a file
sub writeDB {

	# initialize
	my $file = shift;
	my $db   = shift;

	# open file
	open FILE, " > $file" or die "Can't open database ($file): $!. Call Eric.\n";
	binmode( FILE , ":utf8" );

	# initialize the database with field names
	print FILE join( "\t", ( 'key', 'title', 'author', 'edition', 'publication', 'oclc', 'total', 'symbols' ) ), "\n";

	foreach my $key ( sort { $a cmp $b } keys %$db ) {

		# parse
		my $title       = $$db{ $key }->{ 'title' };
		my $author      = $$db{ $key }->{ 'author' };
		my $edition     = $$db{ $key }->{ 'edition' };
		my $publication = $$db{ $key }->{ 'publication' };
		my $oclc        = $$db{ $key }->{ 'oclc' };
		my $total       = $$db{ $key }->{ 'total' };
		my $symbols     = $$db{ $key }->{ 'symbols' };

		# echo
		#print "          key: $key\n";
		#print "        title: $title\n";
		#print "       author: $author\n";
		#print "      edition: $edition\n";
		#print "  publication: $publication\n";
		#print "         oclc: $oclc\n";
		#print "        total: $total\n";
		#print "      symbols: $symbols\n";
		#print "\n";

		# output
		print FILE join( "\t", ( $key, $title, $author, $edition, $publication, $oclc, $total, $symbols ) ), "\n";

	}

	# clean up
	close FILE;

}


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
