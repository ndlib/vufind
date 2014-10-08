<?php
//delete existing authorityResult.txt file
unlink('solr/authority/external_bibcount.txt');

//Retrieve total number of records present in authority core
$url_for_total_records= "http://localhost:8080/solr/authority/select?q=*%3A*&wt=json&rows=0&wt=xml&indent=true";
$records =  json_decode(file_get_contents($url_for_total_records), true);
$total_records = $records['response']['numFound'];

//Find id and headings of all authority records 
for ($start=0; $start<=$total_records-100; $start+=100)	{
	$url_for_id_and_heading = "http://localhost:8080/solr/authority/select?q=*%3A*&fl=id%2Cheading&wt=json&indent=true&start=$start&rows=100";
	$content_for_id_and_heading = file_get_contents($url_for_id_and_heading);
	if($content_for_id_and_heading) {
	  $result_for_id_and_heading = json_decode($content_for_id_and_heading,true);
		foreach($result_for_id_and_heading['response']['docs'] as $doc){
			$id =$doc['id'];
			$heading =$doc['heading'];
			$userinput = "topic:\"$heading\" OR genre:\"$heading\" OR geographic:\"$heading\" OR era:\"$heading\"";
			
			//  Retrieve matched records in biblio core for each headings of authority index and saved id and number of matched records in a text file. 
			$url_for_matched_records = 'http://localhost:8080/solr/biblio/select?q='.urlencode($userinput).'&fl=id&wt=json&indent=true&rows=0';
			$content_for_matched_records = file_get_contents($url_for_matched_records);
			if($content_for_matched_records) {
				$result_for_matched_records = json_decode($content_for_matched_records,true);
			
				// write in a file
				$file = 'solr/authority/external_bibcount.txt';
				$index = $id.'='. $result_for_matched_records['response']['numFound'].PHP_EOL;
				
				// Write the id and corresponding matched records to the file, 
				file_put_contents($file, $index, FILE_APPEND | LOCK_EX);
				
			}
		}
	}
}
?>


