rule bcftools_filter_invariant_sites:
	input:
		vcf="annotated_invariant_{assembly}_{chromosome}.vcf.gz",
		tbi="annotated_invariant_{assembly}_{chromosome}.vcf.gz.tbi"
	output:
		vcf=temp("filtered_invariant_{assembly}_{chromosome}.vcf.gz"),
		tbi=temp("filtered_invariant_{assembly}_{chromosome}.vcf.gz.tbi")
	log:
		"logs/bcftools_filter_invariant_sites/{assembly}_{chromosome}.log"
	threads: 1
	priority: 50
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		# filter variants
		bcftools filter -i 'FILTER="PASS"' -o {output.vcf} -O z {input.vcf}
		
		# index filtered variants
		tabix -f {output.vcf}
		"""
