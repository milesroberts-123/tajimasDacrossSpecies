# add header
echo -e "assembly\tchromosome" > ../workflow/data/chromosomes.tsv

# add names of chromosomes/scaffolds that have genes
grep -v "^#" ../workflow/data/annotations/* | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/.gff3:/\t/g' | sed 's|../workflow/data/annotations/||g' >> ../workflow/data/chromosomes.tsv