# add header
echo -e "assembly\tchromosome" > ../config/chromosomes.tsv

# add names of chromosomes/scaffolds that have genes
grep -v "^#" ../config/annotations/* | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/.gff3:/\t/g' | sed 's|../config/annotations/||g' >> ../config/chromosomes.tsv
