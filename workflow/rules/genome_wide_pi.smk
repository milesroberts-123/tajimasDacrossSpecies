def get_genos(wildcards):
	inputChroms = chroms.loc[chroms["assembly"] == wildcards.assembly, "chromosome"]
	return ["filtered_variantAndInvariant_" + wildcards.assembly + "_" + x + ".table" for x in inputChroms]

rule genome_wide_pi:
	input:
		genos = get_genos,
	output:
		"{assembly}_pairwise-pi.txt"
	log:
		"logs/pairwise_pi/{assembly}.log"
	threads: 3
	resources:
		mem_mb_per_cpu=128000
	conda:
		"../envs/R.yml"
	shell:
		"""
		Rscript scripts/genome-wide-pi.R {output} {threads} {input.genos} &> {log}
		"""
