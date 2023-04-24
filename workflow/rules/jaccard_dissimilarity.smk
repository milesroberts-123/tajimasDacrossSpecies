rule jaccard_dissimilarity:
	input:
		"{assembly}_AllMergedKmerCounts.txt"
	output:
		dissim="{assembly}_jac.txt",
		kmerMatrix="{assembly}_mergedKmerCountsNorm_01.txt"
	log:
		"logs/jaccard_dissimilarity/{assembly}.log"
	params:
		countThresh = config["countThresh"]
	threads: 4
	resources:
		mem_mb_per_cpu=64000
	conda:
		"../envs/R.yml"
	shell:
		"""
		Rscript scripts/pairwise-jaccard-dissimilarity.R {input} {output.dissim} {output.kmerMatrix} {threads} {params.countThresh} &> {log}
		"""
