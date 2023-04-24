rule bcftools_filter_variant_sites:
	input:
		vcf="annotated_variant_{assembly}_{chromosome}.vcf.gz",
		tbi="annotated_variant_{assembly}_{chromosome}.vcf.gz.tbi"
	output:
		vcf=temp("filtered_variant_{assembly}_{chromosome}.vcf.gz"),
		tbi=temp("filtered_variant_{assembly}_{chromosome}.vcf.gz.tbi")
	log:
		"logs/bcftools_filter_variant_sites/{assembly}_{chromosome}.log"
	threads: 1
	priority: 50
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		# filter variants
		bcftools view --max-alleles 2 --exclude-types indels -i 'FILTER="PASS" && F_MISSING<0.2 && MAX(FORMAT/DP)>=5' -o {output.vcf} -O z {input.vcf}

		# index filtered variants
		tabix -f {output.vcf}
		"""
