rule random_kmer_subset:
	input:
		expand("{sampleSe}_se_kmers.txt", sampleSe=samplesSe.index) + expand("{samplePe}_pe_kmers.txt", samplePe=samplesPe.index)
	output:
		"kmerSubset.txt"
	log:
		"logs/random_kmer_subset.log"
	params:
		kmersKept=10000000,
		countThresh=1
	threads: 8
	resources:
		mem_mb_per_cpu=8000
	shell:
		"""
		# 1. concatenate kmer count files
		# 2. remove kmers that occur less than countThresh times because they're due to sequencing errors
		# 3. extract just kmers
		# 4. remove duplicate kmers
		# 5. get a random subset of kmers for downstream analyses
		cat {input} | awk '(($2 > {params.countThresh}))' | cut -f1 | sort --parallel={threads} -S 80% -u  | shuf -n {params.kmersKept} > {output}
		"""
