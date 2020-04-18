#!/usr/bin/perln
use strict;
use warnings;
use open ":std", ":encoding(UTF-8)";

my %people;
if ( defined $ARGV[0] ) {
    my $filename = $ARGV[0];
    open( my $fh, '<:encoding(UTF-8)', $filename )
      or die "Could not open file $filename: $!";
    while ( my $line = <$fh> ) {
        $line =~ s/\s+$//;
        $people{$line} = 1;
    }
}

my $filename = <STDIN>;
$filename =~ s/^\s+|\s+$//g;

open( my $fh, '<:encoding(UTF-8)', $filename )
  or die "Could not open file $filename: $!";

my @array_to_file;
my $i = 0;
while ( my $line = <$fh> ) {
    my $problemrow   = "";
    my $name         = "";
    my $account      = "";
    my $score        = "";
    my $single_score = "";

  LINE: while ( $line =~ /(<tr class='problemrow'>.*?<\/tr>)/g ) {
        $problemrow = $1;
        if ( $problemrow =~ /<a href='\/WIPING\d\/users\/(.*?)'>.*?<\/a>/ ) {
            $account = $1;
        }
        if ( $problemrow =~ /<a href='\/WIPING\d\/users\/.*?'>(.*?)<\/a>/ ) {
            $name = $1;
        }
        if ( $problemrow =~ /<td class='mini'>(\d+\.\d+)<\/td><\/tr>/ ) {
            $score = $1;
        }
        if ( defined $ARGV[0] ) {
            if ( !exists $people{$account} ) {
                next LINE;
            }
        }

        $i = 0;
        my $concat_single_score = "";
        while ( $problemrow =~
/<font title='\d+ submissions'>(\d+\.\d+)<\/font>|<td class='mini'>(-)<\/td>/g
          )
        {
            if ( not defined $1 ) {
                $single_score = "0,0";
            }
            else {
                $single_score = $1;
                $single_score =~ s/\./,/;
            }
            $concat_single_score .= ",\"$single_score\"";
            $i++;
        }
        push( @array_to_file,
            "\n\"$name\",\"$account\"" . $concat_single_score );
    }
}
close $fh;

my $first_row = "\"Name\",\"Username\"";
foreach ( 1 .. $i ) {
    $first_row .= ",\"ZAD$_\"";
}

print STDOUT $first_row;
print STDOUT @array_to_file;

