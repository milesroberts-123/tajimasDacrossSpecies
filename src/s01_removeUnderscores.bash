# replace underscores in assemblies
# conda init bash
# conda activate seqkit

for FILE in ../config/assemblies/*
do
	echo Removing underscores in $FILE...
	seqkit replace -p "_" -r "" $FILE > tmp.fa
	mv tmp.fa $FILE
done

# remove underscores in annotations
for FILE in ../config/annotations/*
do
	echo Removing underscores in $FILE...
	sed 's/_//g' $FILE > tmp.gff3
	mv tmp.gff3 $FILE
done

# specific commands for specific species

# Amaranthus hypochondriacus
#seqkit replace -p "\|quiver\|" -r ""  ../workflow/data/assemblies/amaranthus_hypochondriacus.fa > tmp.fa
#mv tmp.fa ../workflow/data/assemblies/amaranthus_hypochondriacus.fa

#sed 's/|quiver|//g' ../workflow/data/annotations/amaranthus_hypochondriacus.gff3 > tmp.gff3
#mv tmp.gff3 ../workflow/data/annotations/amaranthus_hypochondriacus.gff3
