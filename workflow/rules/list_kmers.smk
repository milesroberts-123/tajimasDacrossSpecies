rule list_kmers:
	input:
		expand("{sampleSe}_se_kmers.txt", sampleSe=samplesSe.index) + expand("{samplePe}_pe_kmers.txt", samplePe=samplesPe.index)
	output:
		temp("kmerList.txt")
	log:
		"logs/list_kmers.log"
	params:
		countThresh=10
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	shell:
		"""
		# 1. concatenate kmer count files
		# 2. remove kmers that occur less than countThresh times because they're due to sequencing errors
		# 3. extract just kmers
		# 4. remove duplicate kmers
		# 5. get a random subset of kmers for downstream analyses
		# 6. sort random k-mer subset so that merging is easier
		cat {input} | awk '(($2 >= {params.countThresh}))' | cut -f1 1> {output} 2> {log}
		"""
