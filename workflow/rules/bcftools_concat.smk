rule bcftools_concat:
	input:
		varvcf="filtered_variant_{assembly}_{chromosome}.vcf.gz",
		vartbi="filtered_variant_{assembly}_{chromosome}.vcf.gz.tbi",
		invarvcf="filtered_invariant_{assembly}_{chromosome}.vcf.gz",
		invartbi="filtered_invariant_{assembly}_{chromosome}.vcf.gz.tbi"
	output:
		vcf="filtered_variantAndInvariant_{assembly}_{chromosome}.vcf.gz",
		tbi="filtered_variantAndInvariant_{assembly}_{chromosome}.vcf.gz.tbi"
	log:
		"logs/bcftools_concat/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=get_mem_mb_per_cpu,
		time=get_time
	priority: 50
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		# concatenate variant and invariant sites
		bcftools concat \
			--allow-overlaps \
			{input.varvcf} {input.invarvcf} \
			-O z -o {output.vcf} &> {log}

		# index concat file
		tabix -f {output.vcf}
		"""
