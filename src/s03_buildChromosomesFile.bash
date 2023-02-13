# add header
echo -e "assembly\tchromosome" > ../workflow/data/chromosomes.tsv

# add names of chromosomes/scaffolds that have genes
grep -v "^#" ../workflow/data/annotations/* | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/.gff3:/\t/g' | sed 's|../workflow/data/annotations/||g' >> ../workflow/data/chromosomes.tsv


#echo Creating file to store chromosome index...
#touch ../workflow/data/chromosomes.tsv

#for FILE in ../workflow/data/annotations/*
#do
#	echo Adding chromosomes from $FILE to index...
#	grep -v "^#" $FILE | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/.gff3:/\t/g' >> ../workflow/data/chromosomes.tsv
#done


#grep -v "^#" annotations/arabidopsis_halleri.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' > chromosomes.tsv
#grep -v "^#" annotations/arabidopsis_lyrata.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_lyrata\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/arabidopsis_thaliana.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_thaliana\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/boechera_stricta.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/brassica_oleracea.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/brassica_rapa.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/capsella_grandiflora.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/capsella_rubella.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/capsella_rubella\t/g' >> chromosomes.tsv
