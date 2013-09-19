#!/usr/bin/perl

# stats-map.pl - place CRRA searchers on the globe

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 10, 2011 - beginnings, and based on map.cgi from Great Books Survey

# configure
use constant DSN      => 'dbi:mysql:crra_transactions:mysql.library.nd.edu';
use constant PASSWORD => 'portal';
use constant USERNAME => 'catholic';

# include
use DBI;
use strict;

# initalize
my $dbh = DBI->connect( DSN, USERNAME, PASSWORD );

my $sth = $dbh->prepare( 'SELECT DISTINCT address FROM votes' );
$sth->execute;
open OUTPUT, ' > ' . MARKERS;
print OUTPUT '<markers>';
while ( my @row = $sth->fetchrow_array ) {

	my $record = $gi->record_by_addr( $row[ 0 ] );
	my $lat = '';
	my $lng = '';
	if ( $record ) {
	
		my $lat = $record->latitude;
		my $lng = $record->longitude;
		print OUTPUT "<marker lat='$lat' lng='$lng' />";
		
	}

}
print OUTPUT '</markers>';
close OUTPUT;

# get vote counts
$sth = $dbh->prepare( "SELECT COUNT(address), COUNT(DISTINCT address) FROM votes" );
$sth->execute;
my @result = $sth->fetchrow_array;
my $number_of_votes = $result[ 0 ];
my $number_of_people = $result[ 1 ];

# done
print $cgi->header;
print &template( $number_of_votes, $number_of_people );
exit;

sub template {

	my $v = &commify( shift );
	my $p = &commify( shift );
	
	return<<EOF;
<html>
<head>
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAycmiRMA1oopdRgvNcsKRVRRhh_2VEiv5mQ1CqbxC104jfY-S1xS5hjNnJOMPpBd6QuzUuYqyouD1bQ" type="text/javascript"></script>
	<script type="text/javascript">

    //<![CDATA[

    function load() {
    
      if (GBrowserIsCompatible()) {
      
        // create a map object, add navigation, center on South Bend
        var map = new GMap2(document.getElementById("map"));
        map.addControl(new GLargeMapControl());
        map.addControl(new GMapTypeControl());
        map.setCenter(new GLatLng(20.4715, -83.1430), 2);
        
		// get all the markers
		var request = GXmlHttp.create();
		request.open("GET", "/sandbox/great-books/survey/markers.xml", true);
		request.onreadystatechange = function() {
		
			if (request.readyState == 4) {
			
				var xmlDoc = request.responseXML;
				var markers = xmlDoc.documentElement.getElementsByTagName("marker");
				
				// process each marker
				for (var i = 0; i < markers.length; i++) {
				
					// obtain the attribues of each marker
					var lat = parseFloat(markers[i].getAttribute("lat"));
					var lng = parseFloat(markers[i].getAttribute("lng"));
					var point = new GLatLng(lat,lng);
					var html = markers[i].getAttribute("html");
					
					// do the work
					var marker = createMarker(point,html);
					map.addOverlay(marker);
					
				}
				
			}
			
		}
		
		request.send(null);
		
      }
      
    }

 	function createMarker(point,html) {
 	
		var marker = new GMarker(point);
		return marker;
		
	}

   //]]>
   
    </script>
    <title>Great Books Survey: From where are people voting</title>
</head>
<body onload="load()" onunload="GUnload()" style='margin: 3%; text-align: center'>

	<h1>From where are people voting</h1>
	
	<div id="map" style="margin: auto; width: 800px; height: 475px"></div>
	
	<p>The Great Books Survey has been answered $v times by $p people. <a href="./">Back to survey</a>.</p>
	
</body>
</html>
EOF

}

sub commify {

	# commify a number. Perl Cookbook, 2.17, p. 64
	my $text = reverse $_[0];
	$text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
	return scalar reverse $text;
	
}
