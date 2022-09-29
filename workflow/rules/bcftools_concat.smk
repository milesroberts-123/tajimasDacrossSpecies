rule bcftools_concat:
	input:
		"filtered_variant_{chrom}.vcf.gz",
		"filtered_invariant_{chrom}.vcf.gz"
	output:
		"filtered_variantAndInvariant_{chrom}.vcf.gz"
	log:
		"logs/bcftools_concat/bcftools_concat_{chrom}.log"
	threads: 1
	envmodules:
		"GCC/10.2.0 BCFtools/1.11"	
	shell:
		"""
		bcftools concat \
			--allow-overlaps \
			{input} \
			-O z -o {output} &> {log}
		"""
