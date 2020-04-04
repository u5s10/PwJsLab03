#!/usr/bin/perl
use strict;
use warnings;
use open ":std", ":encoding(UTF-8)";

my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";

while(my $line = <$fh>){
    my $problemrow = "";
    my $name = "";
    my $account = "";
    my $score = "";
    my $single_score = "";
    
    while($line =~ /(<tr class='problemrow'>.*?<\/tr>)/g){
	$problemrow = $1;
	if($problemrow =~ /<a href='\/WIPING\d\/users\/(.*?)'>.*?<\/a>/){
	    $account = $1;
	}
	if($problemrow =~ /<a href='\/WIPING\d\/users\/.*?'>(.*?)<\/a>/){
	    $name = $1;
	}
	if($problemrow =~ /<td class='mini'>(\d+\.\d+)<\/td><\/tr>/){
	    $score = $1;
	}
	printf ("Name: %-40s",$name);

	while($problemrow =~ /<font title='\d+ submissions'>(\d+\.\d+)<\/font>|<td class='mini'>(-)<\/td>/g){
	    if(not defined $1){
		$single_score = "0.0";
	    }else{
		$single_score = $1;
	    }
	    printf ("%-6s", $single_score);
	}
	print "\n";
    }
}
close $fh;
