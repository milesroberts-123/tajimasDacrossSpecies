rule jaccard_dissimilarity:
	input:
		"mergedKmerCounts.txt"
	output:
		dissim="jac.txt",
		kmerMatrix="mergedKmerCountsNorm_01.txt"
	log:
		"logs/jaccard_dissimilarity.log"
	params:
		countThresh=5 # mark a k-mer as present if it has a count equal to or greater than this threshold
	threads: 5
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/R.yml"
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"""
		Rscript scripts/jaccard_dissimilarity.R {input} {output.dissim} {output.kmerMatrix} {threads} {params.countThresh} &> {log}
		
		# merge output of R script into one file
		cat *_{output.dissim} > {output.dissim}

		# remove intermediate files
		rm *_{output.dissim}
		"""
