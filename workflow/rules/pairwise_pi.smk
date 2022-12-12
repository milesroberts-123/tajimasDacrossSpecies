rule pairwise_pi:
	input:
		genos = expand("filtered_variantAndInvariant_{chrom}.012", chrom = chroms.index),
		indvs = expand("filtered_variantAndInvariant_{chrom}.012.indv", chrom = chroms.index)
	output:
		"pairwise-pi.txt"
	log:
		"logs/pairwise_pi.log"
	params:
		ploidy=2
	threads: 5
	resources:
		mem_mb_per_cpu=64000
	conda:
		"../envs/R.yml"
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"""
		Rscript scripts/pairwise-pi.R {params.ploidy} {output} {threads} {input.indvs} {input.genos} &> {log}
		
		# merge output of R script into one file
		cat *_{output} > {output}

		# remove intermediate files
		rm *_{output}
		"""
