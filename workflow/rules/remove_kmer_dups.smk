rule remove_kmer_dups:
	input:
		"kmerList.txt"
	output:
		"kmerListNoDups.txt"
	log:
		"logs/random_kmer_subset.log"
	params:
		kmersKept=10000000
	threads: get_thread_count
	resources:
		mem_mb_per_cpu=get_mem_mb
	shell:
		"""
		# 1. concatenate kmer count files
		# 2. remove kmers that occur less than countThresh times because they're due to sequencing errors
		# 3. extract just kmers
		# 4. remove duplicate kmers
		# 5. get a random subset of kmers for downstream analyses
		# 6. sort random k-mer subset so that merging is easier
		sort --parallel={threads} -S 80% -u {input} 1> {output} 2> {log}
		"""
