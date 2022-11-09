rule bcftools_concat:
	input:
		"filtered_variant_{chrom}.vcf.gz",
		"filtered_invariant_{chrom}.vcf.gz"
	output:
		"filtered_variantAndInvariant_{chrom}.vcf.gz"
	log:
		"logs/bcftools_concat/bcftools_concat_{chrom}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	envmodules:
		"GCC/10.2.0 BCFtools/1.11"	
	shell:
		"""
		bcftools concat \
			--allow-overlaps \
			{input} \
			-O z -o {output} &> {log}

		# remove temporary index
		rm filtered_variant_{wildcards.chrom}.vcf.gz.tbi
		rm filtered_invariant_{wildcards.chrom}.vcf.gz.tbi
		"""
