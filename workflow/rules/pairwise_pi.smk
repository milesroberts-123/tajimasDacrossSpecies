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
		mem_mb_per_cpu=2000
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"Rscript scripts/pairwise-pi.R {params.ploidy} {output} {input.indvs} {input.genos}"
