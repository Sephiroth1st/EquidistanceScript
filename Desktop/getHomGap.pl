#!/usr/bin/perl

# this script is used for merging the blast results of ortholog proteins in 3 species 
# simply using this script:
# perl getHomGap.pl [blastFile1] [blastFile2] [blastFile3] [outFile]

open FILE1,"@ARGV[0]" or die;
open FILE2,"@ARGV[1]" or die;
open FILE3,"@ARGV[2]" or die;
open FILE4,">@ARGV[3]" or die;

# print the header first 
print FILE4 "query1\tquery2\tquery3\tPiden1-2\tPiden2-3\tPiden1-3\tleng1-2\tleng2-3\tleng1-3\tgap1-2\tgap2-3\tgap1-3\n";
while(<FILE1>){
	chomp;
	my @seq1=split /\t/;
	while(<FILE2>){
		chomp;
		my @seq2=split /\t/;
		if($seq1[1] eq $seq2[0] ){
			while(<FILE3>){
				chomp;
				my @seq3=split /\t/;
				if($seq3[0] eq $seq1[0] and $seq3[1] eq $seq2[1] ){
					print FILE4 "$seq1[0]\t$seq1[1]\t$seq2[1]\t$seq1[2]\t$seq2[2]\t$seq3[2]\t$seq1[3]\t$seq2[3]\t$seq3[3]\t$seq1[5]\t$seq2[5]\t$seq3[5]\n";
				}
			} 
			close FILE3;
			open FILE3,"@ARGV[2]" or die;
		}

	}
	close FILE2;
	open FILE2,"@ARGV[1]" or die;
}
close FILE1;
close FILE4;

