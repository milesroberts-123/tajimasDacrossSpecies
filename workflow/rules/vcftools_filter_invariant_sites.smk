rule vcftools_filter_invariant_sites:
	input:
		"annotated_invariant_{chrom}.vcf.gz"
	output:
		temp("filtered_invariant_{chrom}.vcf.gz")
	log:
		"logs/vcftools_filter_invariant_sites/vcftools_filter_invariant_sites_{chrom}.log"
	threads: 1
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	shell:
		"""
		# filter variants
		vcftools --gzvcf {input} \
			--remove-filtered-all \
			--remove-indels \
			--min-meanDP 10 \
			--max-meanDP 75 \
			--max-missing 0.8 \
			--recode \
			--recode-INFO-all \
			--stdout | bgzip -c > {output}

		# index filtered variants
		tabix {output}
		"""
