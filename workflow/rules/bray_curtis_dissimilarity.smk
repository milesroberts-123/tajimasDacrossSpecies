rule bray_curtis_dissimilarity:
	input:
		"{assembly}_AllMergedKmerCounts.txt"
	output:
		dissim="{assembly}_bcd.txt",
		kmerMatrix="{assembly}_mergedKmerCountsNorm.txt"
	log:
		"logs/bray_curtis_dissimilarity/{assembly}.log"
	threads: 4
	resources:
		mem_mb_per_cpu=64000
	conda:
		"../envs/R.yml"
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"""
		Rscript scripts/pairwise-bray-curtis-dissimilarity.R {input} {output.dissim} {output.kmerMatrix} {threads} &> {log}
		
		# merge output of R script into one file
		cat *_{output.dissim} > {output.dissim}

		# remove intermediate files
		rm *_{output.dissim}
		"""
