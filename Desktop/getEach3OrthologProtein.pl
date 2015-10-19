#!/bin/perl

# author: luodenghui		date:2015.4.1
# this script is used to get each ortholog protein according the specific listFile from 3 fastaFile to cluFile
# use this script like this: 
# perl getEach3OrthologProtein.pl -list [listFile] -f1 [fastaFile1] -f2 [fastaFile2] -f3 [fastaFile3]
# listFile is lines which each has 3 proteins ID in fasta format with tab character.
# 3 fastaFiles must correspond with the listFile and keep the same order.

use Getopt::Long;
GetOptions(
	'list:s' => \$list,
	'f1:s' => \$f1,
	'f2:s' => \$f2,
	'f3:s' => \$f3,
);
unless ($list && $f1 && $f2 && $f3) {
	&USAGE;
	die;
}
open LIST,"$list" or die "the file $list is not exist." ;

while (<LIST>) {
	chomp;
	@list=split /\t/;
	open FASTA3,"$f3" or die "the file $f3 is not exist." ;
	while(<FASTA3>){
		chomp;
		@line=split / /;
		if(@line[1]){
			$op=0;
			if(@line[0] eq ">".$list[2]){
				$l = join(' ',@line);
				@l =split  /HUMAN | OS/,$l;
				$outfile=@l[1].".fasta";
				$outfile=~s/\// or /;
				open OUTFILE,">$outfile" or die;
				$op=1;
				print OUTFILE $l;
			}
		}elsif($op==1){
			print OUTFILE @line;
			print OUTFILE "\n";
		}
	}
	close FASTA3;

	$op=0;
	open FASTA2,"$f2" or die "the file $f2 is not exist." ;
	while(<FASTA2>){
		chomp;
		@line=split / /;
		if(@line[1]){
			$op=0;
			if(@line[0] eq ">".$list[1]){
				$l = join(' ',@line);
				$op=1;
				print OUTFILE $l;
			}
		}elsif($op==1){
			print OUTFILE @line;
			print OUTFILE "\n";
		}
	}
	close FASTA2;

	$op=0;
	open FASTA1,"$f1" or die "the file $f1 is not exist." ;
	while(<FASTA1>){
		chomp;
		@line=split / /;
		if(@line[1]){
			$op=0;
			if(@line[0] eq ">".$list[0]){
				$l = join(' ',@line);
				$op=1;
				print OUTFILE $l;
			}
		}elsif($op==1){
			print OUTFILE @line;
			print OUTFILE "\n";
		}
	}
	close FASTA1;

	close OUTFILE;
}

sub USAGE{
	print "***************** getEach3OrthologProtein.pl********************\n";
	print "use this script like this: \nperl getEach3OrthologProtein.pl -list [listFile] -f1 [fastaFile1] -f2 [fastaFile2] -f3 [fastaFile3]\n";
	print "listFile is lines which each has 3 proteins ID in fasta format with tab character.\n";
	print "3 fastaFiles must correspond with the listFile and keep the same order.\n";
};
