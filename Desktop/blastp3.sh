#!/bin/bash
#$ -cwd
## This script is used to do protein blast among three organism. It needs the ncbi blast+ software and  the getHomGap.pl script.
## Simply using this script: 
## blastp3.sh [fastaFile1] [fastaFile2] [fastaFile3]
## When this script completed, you'll get a table which three organism are matched.　€€See details in getHomGap.pl.

## GET THE SEQUENCE NAMES
QUERY1=${1%.*}
QUERY2=${2%.*}
QUERY3=${3%.*}

NAME1=${QUERY1##*-}
NAME2=${QUERY2##*-}
NAME3=${QUERY3##*-}

## RESULTS_DIR=DATA_DIR
DATA_DIR=/home/luodh/
DATABASE_EXEC=/share/luodh/ncbi-blast-2.2.30+/bin/makeblastdb
BLASTP_EXEC=/share/luodh/ncbi-blast-2.2.30+/bin/blastp

GETHOMGAP_EXEC=${DATA_DIR}blast/getHomGap.pl

## AUTO FORM BLAST FILENAMES
BLASTPOUTFILE1=${NAME1}-${NAME2}.blast
BLASTPOUTFILE2=${NAME1}-${NAME3}.blast
BLASTPOUTFILE3=${NAME2}-${NAME3}.blast

## AUTO FORM INTERMEDIATE FILENAMES
GT1=${NAME1}-${NAME2}_gap.txt
GT2=${NAME1}-${NAME3}_gap.txt
GT3=${NAME2}-${NAME3}_gap.txt
# GTM=${NAME1}-${NAME2}_${NAME2}-${NAME3}_gap.txt
GTR=${NAME1}-${NAME2}-${NAME3}_gap.txt

## BUILD THE BLAST DATEBASES
if [ ! -f $QUERY2".phr" ]; then
	$DATABASE_EXEC \
		-in $2 \
		-dbtype prot \
		-parse_seqids \
		-out $QUERY2 
fi
if [ ! -f $QUERY3".phr" ]; then
	$DATABASE_EXEC \
		-in $3 \
		-dbtype prot \
		-parse_seqids \
		-out $QUERY3 
fi
## DO BLAST
if [ ! -f $BLASTPOUTFILE1 ]; then
	$BLASTP_EXEC \
		-query $1 \
		-db $QUERY2 \
		-out $BLASTPOUTFILE1 \
		-outfmt "6 std" \
		-evalue 1e-5  \
		-num_threads 16 
fi
if [ ! -f $BLASTPOUTFILE2 ]; then
	$BLASTP_EXEC \
		-query $1 \
		-db $QUERY3 \
		-out $BLASTPOUTFILE2 \
		-outfmt "6 std" \
		-evalue 1e-5  \
		-num_threads 16 
fi
if [ ! -f $BLASTPOUTFILE3 ]; then
	$BLASTP_EXEC \
		-query $2 \
		-db $QUERY3 \
		-out $BLASTPOUTFILE3 \
		-outfmt "6 std" \
		-evalue 1e-5  \
		-num_threads 16 
fi

## EXTRACT THE ORTHOLOGS
if [ ! -f $GT1 ]; then
sort -k 12gr $BLASTPOUTFILE1 >$GT1
awk '!a[$2]++' $GT1 >${GT1}_2
awk '!a[$1]++' $GT1 >${GT1}_1
awk 'NR==FNR{a[$1"_"$2]=1}NR>FNR{if(a[$1"_"$2]) print $0}' ${GT1}_1 ${GT1}_2 >$GT1
rm ${GT1}_1 ${GT1}_2
fi
if [ ! -f $GT2 ]; then
sort -k 12gr $BLASTPOUTFILE2 >$GT2
awk '!a[$2]++' $GT2 >${GT2}_2
awk '!a[$1]++' $GT2 >${GT2}_1
awk 'NR==FNR{a[$1"_"$2]=1}NR>FNR{if(a[$1"_"$2]) print $0}' ${GT2}_1 ${GT1}_2 >$GT2
rm ${GT2}_1 ${GT2}_2
fi
if [ ! -f $GT3 ]; then
sort -k 12gr $BLASTPOUTFILE3 >$GT3
awk '!a[$2]++' $GT3 >${GT3}_2
awk '!a[$1]++' $GT3 >${GT3}_1
awk 'NR==FNR{a[$1"_"$2]=1}NR>FNR{if(a[$1"_"$2]) print $0}' ${GT3}_1 ${GT3}_2 >$GT3
rm ${GT3}_1 ${GT3}_2
fi

## GET HOMOLOGS WITHOUT LENGTH LIMIT
$GETHOMGAP_EXEC $GT1 $GT3 $GT2 $GTR

