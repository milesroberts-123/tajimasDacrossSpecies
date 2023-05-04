rule gatk_variants_to_table:
	input:
		vcf="filtered_variantAndInvariant_{assembly}_{chromosome}.vcf.gz",
		tbi="filtered_variantAndInvariant_{assembly}_{chromosome}.vcf.gz.tbi"
	output:
		"filtered_variantAndInvariant_{assembly}_{chromosome}.table",
	log:
		"logs/gatk_variants_to_table/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=get_mem_mb_per_cpu,
		time=get_time
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		gatk VariantsToTable -V {input.vcf} -F CHROM -F POS -F DP -F AN -F AC -O {output} &> {log}
		"""
