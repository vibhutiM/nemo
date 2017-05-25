#!/usr/bin/perl
 
 use strict;
 
 my $fn = shift @ARGV;
 
 die "USAGE convert.pl input.idx output.txt"
     if !$fn;
 
 my $output = shift @ARGV;
 print "Input $fn\n";
 print "Output $output\n";
 
 open ( FH, "<", $fn) 
     or die "Can't open file";
 binmode(FH);
 
 $/ = \8;
 
 my ($zero, $type, $dim, $length) = unpack('S C C l>', <FH>);
 
 print "Data type $type\n";
 print "Dimensions $dim\n";
 print "Number of items $length\n";
 
 die "This converter can only handle type=8 (unsigned char) data"
     if ($type != 8);
     
 
 my $itemno = 0;
 my $chunkno = 1;
 
 if ($dim == 1) {
     # label file
     open(OUT, ">", $output) 
 	or die "Can't open file";
 
     $/ = \1;
 
     print OUT "SEG0";
     while (<FH>) {
         if ($itemno++ == 1000) {
           print OUT "\nSEG$chunkno";
           $itemno = 1;
 	  $chunkno++;
         } 
 	my $label = unpack('C', $_);
 	print OUT " $label";
     }
     print OUT "\n";
     close OUT;
 }
 elsif ($dim == 3) {
     # image feature file
     open(OUT, ">", $output) 
 	or die "Can't open file";
 
     my $pixelno = 0;
 
     my ($rows, $cols) = unpack('l> l>', <FH>);
     print "Rows $rows\n";
     print "Cols $cols\n";
     my $size = $rows * $cols;
 
     $/ = \1;
 
     print OUT "SEG0 [";
     while (<FH>) {
 	my $pixel = unpack('C', $_);
         if ($itemno == 1000) {
 	  print OUT " ]\nSEG$chunkno [";
           $chunkno++;
           $itemno = 0;
         } 
 	print OUT " ".$pixel/256;
 	if (++$pixelno == $size) {
 	    $itemno++;
 	    $pixelno = 0;
 	    print OUT "\n";
 	}
     }
     print OUT "\n]\n";
 
     close OUT;
 }
 else {
     die "This converter can only handle 1- and 3-dimensional data."
 }
 
 close FH;