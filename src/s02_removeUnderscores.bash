# replace underscores in assemblies
# conda init bash
# conda activate seqkit

for FILE in ../workflow/data/assemblies/*
do
	echo Removing underscores in $FILE...
	seqkit replace -p "_" -r "" $FILE > tmp.fa
	mv tmp.fa $FILE
done

# remove underscores in annotations
for FILE in ../workflow/data/annotations/*
do
	echo Removing underscores in $FILE...
	sed 's/_//g' $FILE > tmp.gff3
	mv tmp.gff3 $FILE
done

# specific commands for specific species
# Amaranthus hypochondriacus
#seqkit replace -p " pilon" -r ""  ../workflow/data/assemblies/amaranthus_hypochondriacus.fa > tmp.fa 
#mv tmp.fa ../workflow/data/assemblies/amaranthus_hypochondriacus.fa

#sed 's/ pilon//g' ../workflow/data/annotations/amaranthus_hypochondriacus.gff3 > tmp.gff3
#mv tmp.gff3 ../workflow/data/annotations/amaranthus_hypochondriacus.gff3
