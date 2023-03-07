rule bcftools_concat:
	input:
		"filtered_variant_{assembly}_{chromosome}.vcf.gz",
		"filtered_invariant_{assembly}_{chromosome}.vcf.gz"
	output:
		"filtered_variantAndInvariant_{assembly}_{chromosome}.vcf.gz"
	log:
		"logs/bcftools_concat/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/bcftools.yml"
	envmodules:
		"GCC/10.2.0 BCFtools/1.11"	
	shell:
		"""
		bcftools concat \
			--allow-overlaps \
			{input} \
			-O z -o {output} &> {log}

		# index concat file
		tabix {output}

		# remove temporary index
		rm filtered_variant_{wildcards.assembly}_{wildcards.chromosome}.vcf.gz.tbi
		rm filtered_invariant_{wildcards.assembly}_{wildcards.chromosome}.vcf.gz.tbi
		"""
