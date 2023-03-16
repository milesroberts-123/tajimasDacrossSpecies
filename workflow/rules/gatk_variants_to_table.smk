rule gatk_variants_to_table:
	input:
		"filtered_variantAndInvariant_{assembly}_{chromosome}.vcf.gz"
	output:
		"filtered_variantAndInvariant_{assembly}_{chromosome}.table",
	log:
		"logs/gatk_variants_to_table/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		gatk VariantsToTable -V {input} -F CHROM -F POS -F DP -F AN -F AC -O {output}
		"""
