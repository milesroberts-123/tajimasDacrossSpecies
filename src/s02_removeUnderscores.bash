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
