rule bcftools_filter_variant_sites:
	input:
		"annotated_variant_{assembly}_{chromosome}.vcf.gz"
	output:
		temp("filtered_variant_{assembly}_{chromosome}.vcf.gz")
	log:
		"logs/bcftools_filter_variant_sites/{assembly}_{chromosome}.log"
	threads: 1
	priority: 50
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/bcftools.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	shell:
		"""
		# filter variants
		bcftools view --max-alleles 2 --exclude-types indels -i 'FILTER="PASS" && F_MISSING<0.2 && MAX(FORMAT/DP)>=5' -o {output} -O z {input}

		# index filtered variants
		tabix {output}

		# remove temporary index
		rm {input}.tbi
		"""
