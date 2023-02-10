
grep -v "^#" ../workflow/data/annotations/*.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/.gff3:/\t/g' > chromosomes.tsv

#grep -v "^#" annotations/arabidopsis_halleri.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' > chromosomes.tsv
#grep -v "^#" annotations/arabidopsis_lyrata.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_lyrata\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/arabidopsis_thaliana.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_thaliana\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/boechera_stricta.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/brassica_oleracea.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/brassica_rapa.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/capsella_grandiflora.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/arabidopsis_halleri\t/g' >> chromosomes.tsv
#grep -v "^#" annotations/capsella_rubella.gff3 | awk '(($3 == "gene"))' | cut -f1 | sort -u | sed 's/^/capsella_rubella\t/g' >> chromosomes.tsv
