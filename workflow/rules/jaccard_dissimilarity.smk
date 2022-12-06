rule jaccard_dissimilarity:
	input:
		"mergedKmerCounts.txt"
	output:
		dissim="jac.txt",
		kmerMatrix="mergedKmerCountsNorm_01.txt"
	log:
		"logs/jaccard_dissimilarity.log"
	threads: 5
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/R.yml"
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"""
		Rscript scripts/jaccard_dissimilarity.R {input} {output.dissim} {output.kmerMatrix} {threads} &> {log}
		
		# merge output of R script into one file
		cat *_{output.dissim} > {output.dissim}
		"""
