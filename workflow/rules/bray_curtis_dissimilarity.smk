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
	shell:
		"""
		Rscript scripts/pairwise-bray-curtis-dissimilarity.R {input} {output.dissim} {output.kmerMatrix} {threads} &> {log}
		"""
