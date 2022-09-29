#!/bin/bash

#Parse input arguments
while getopts g:G:b: option; do
		case "${option}" in
			g) GFF=${OPTARG};;
			G) GENOME=${OPTARG};;
			b) BED=${OPTARG};;
		esac
	done

#Extract just genes in bed file format
#Chr, start, end, gene name
#Must convert from GFF-style counting to BED-style counting
# Extract list of CDS coordinates, but merge overlapping CDS intervals
# for now, just extract the top ten regions
cat $GFF | awk '(($3 == "gene"))' | grep -v "^#" | cut -f 1,4,5,9 | sort -k1,1 -k2,2n  > data/genes.bed

# Get 2.5 kb upstream and downstream regions
bedtools flank -i data/genes.bed -g $GENOME -b 2500 > data/upstreamAndDownstream.bed

# merge together upstream, downstream, and gene regions to get all intervals for genotyping
cat data/genes.bed data/upstreamAndDownstream.bed | sort -k1,1 -k2,2n | bedtools merge > $BED
