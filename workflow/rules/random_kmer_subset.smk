rule random_kmer_subset:
	input:
		"kmerListNoDups.txt"
	output:
		temp("kmerRandomSubset.txt")
	log:
		"logs/random_kmer_subset.log"
	params:
		kmersKept=10000000
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	shell:
		"""
		# 1. concatenate kmer count files
		# 2. remove kmers that occur less than countThresh times because they're due to sequencing errors
		# 3. extract just kmers
		# 4. remove duplicate kmers
		# 5. get a random subset of kmers for downstream analyses
		# 6. sort random k-mer subset so that merging is easier
		shuf -n {params.kmersKept} {input} | sort 1> {output} 2> {log}
		"""
