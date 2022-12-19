def get_genos(wildcards):
	inputChroms = chroms.loc[chroms["assembly"] == wildcards.assembly, "chromosome"]
	return ["filtered_variantAndInvariant_" + wildcards.assembly + "_" + x + ".012" for x in inputChroms]

def get_indvs(wildcards):
	inputChroms = chroms.loc[chroms["assembly"] == wildcards.assembly, "chromosome"]
	return ["filtered_variantAndInvariant_" + wildcards.assembly + "_" + x + ".012.indv" for x in inputChroms]

rule pairwise_pi:
	input:
		genos = get_genos,
		indvs = get_indvs
	output:
		"{assembly}_pairwise-pi.txt"
	log:
		"logs/pairwise_pi/{assembly}.log"
	params:
		ploidy=2
	threads: 3
	resources:
		mem_mb_per_cpu=128000
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
