#Define recursive join function that works on multiple files
#code from: https://unix.stackexchange.com/questions/364735/merge-multiple-files-with-join
# I know that the inputs are sorted before-hand, so add --nocheck-order
# You can add "-a 1 -a 2" if you want to print unpairable lines too
xjoin() {
	local f

	if [ "$#" -lt 2 ]; then
		echo "xjoin: need at least 2 files" >&2
		return 1
	elif [ "$#" -lt 3 ]; then
		#join --nocheck-order -a 1 -a 2 -e'0' -o auto "$1" "$2"
		join --nocheck-order -j 1 -a 1 -e "0" -o auto "$1" "$2"
	else
		f=$1
		shift
		#join --nocheck-order -a 1 -a 2 -e'0' -o auto "$f" <(xjoin "$@")
		join --nocheck-order -j 1 -a 1 -e "0" -o auto "$f" <(xjoin "$@")
	fi
}

# Perform join on multiple files
# add header to file first, then append joined results
echo kmerSubset.txt *kmers.txt

echo kmerSubset.txt *kmers.txt | sed 's/_se_kmers.txt//g' | sed 's/_pe_kmers.txt//g' | sed 's/Subset.txt//' > testOutput.txt
#xjoin <(sed 's/$/ 1/g' kmerSubset.txt) *kmers.txt >> testOutput.txt
xjoin kmerSubset.txt *kmers.txt >> testOutput.txt
