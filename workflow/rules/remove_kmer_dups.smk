rule remove_kmer_dups:
	input:
		"kmerList.txt"
	output:
		temp("kmerListNoDups.txt")
	log:
		"logs/remove_kmer_dups.log"
	threads: 1
	resources:
		mem_mb_per_cpu=128000
	shell:
		"""
		# 1. concatenate kmer count files
		# 2. remove kmers that occur less than countThresh times because they're due to sequencing errors
		# 3. extract just kmers
		# 4. remove duplicate kmers, no need to sort beforehand
		# 5. get a random subset of kmers for downstream analyses
		# 6. sort random k-mer subset so that merging is easier
		# sort --parallel={threads} -S 80% -u {input} 1> {output} 2> {log}
		awk '!a[$0]++' {input} 1> {output} 2> {log}
		"""
