rule jaccard_dissimilarity:
	input:
		"mergedKmerCounts.txt"
	output:
		"jac.txt",
		"mergedKmerCountsNorm_01.txt"
	log:
		"logs/jaccard_dissimilarity.log"
	threads: 10
	resources:
		mem_mb_per_cpu=32000
	conda:
		"../envs/R.yml"
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"""
		Rscript scripts/jaccard_dissimilarity.R {input} {output} {threads} &> {log}
		
		# merge output of R script into one file
		cat *_{output} > {output}
		"""
