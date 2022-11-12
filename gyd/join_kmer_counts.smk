rule join_kmer_counts:
	input:
		"kmerSubset.txt",
		expand("{sampleSe}_se_kmers.txt", sampleSe=samplesSe.index),
		expand("{samplePe}_pe_kmers.txt", samplePe=samplesPe.index)
	output:
		"mergedKmerCounts.txt"
	log:
		"logs/join_kmer_counts.log"
	threads: 1
	resources:
		mem_mb_per_cpu=64000
	shell:
		"""
		#Define recursive join function that works on multiple files
		#code from: https://unix.stackexchange.com/questions/364735/merge-multiple-files-with-join
		# I know that the inputs are sorted before-hand, so add --nocheck-order
		xjoin() {{
			local f

			if [ "$#" -lt 2 ]; then
				echo "xjoin: need at least 2 files" >&2
				return 1
			elif [ "$#" -lt 3 ]; then
				join --nocheck-order -a 1 -a 2 -e'0' -o auto "$1" "$2"
			else
				f=$1
				shift
				join --nocheck-order -a 1 -a 2 -e'0' -o auto "$f" <(xjoin "$@")
			fi
		}}

		# Perform join on multiple files
		# add header to file first, then append joined results
		echo {input} | sed 's/_se_kmers.txt//g' | sed 's/_pe_kmers.txt//g' | sed 's/Subset.txt//' > {output}
		xjoin {input} >> {output}
		"""
