rule vcftools_filter_variant_sites:
	input:
		"annotated_variant_{assembly}_{chromosome}.vcf.gz"
	output:
		temp("filtered_variant_{assembly}_{chromosome}.vcf.gz")
	log:
		"logs/vcftools_filter_variant_sites/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/vcftools.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	shell:
		"""
		# filter variants
		vcftools --gzvcf {input} \
			--remove-filtered-all \
			--min-meanDP 10 \
			--max-meanDP 75 \
			--max-missing 0.8 \
			--recode \
			--recode-INFO-all \
			--stdout | bgzip -c > {output}

		# index filtered variants
		tabix {output}

		# remove temporary index
		rm {input}.tbi
		"""
