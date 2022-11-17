rule bray_curtis_dissimilarity:
	input:
		"mergedKmerCounts.txt"
	output:
		"bcd.txt",
		"mergedKmerCountsNorm.txt"
	log:
		"logs/bray_curtis_dissimilarity.log"
	threads: 10
	resources:
		mem_mb_per_cpu=64000
	conda:
		"../envs/R.yml"
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"Rscript scripts/bray_curtis_dissimilarity.R {input} {output} {threads} &> {log}"
