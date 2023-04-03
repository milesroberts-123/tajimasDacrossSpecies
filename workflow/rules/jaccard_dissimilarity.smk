rule jaccard_dissimilarity:
	input:
		"{assembly}_AllMergedKmerCounts.txt"
	output:
		dissim="{assembly}_jac.txt",
		kmerMatrix="{assembly}_mergedKmerCountsNorm_01.txt"
	log:
		"logs/jaccard_dissimilarity/{assembly}.log"
	params:
		countThresh=5 # mark a k-mer as present if it has a count equal to or greater than this threshold
	threads: 1
	resources:
		mem_mb_per_cpu=128000
	conda:
		"../envs/R.yml"
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"""
		Rscript scripts/pairwise-jaccard-dissimilarity.R {input} {output.dissim} {output.kmerMatrix} {threads} {params.countThresh} &> {log}
		
		# merge output of R script into one file
		cat *_{output.dissim} > {output.dissim}

		# remove intermediate files
		rm *_{output.dissim}
		"""
