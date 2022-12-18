rule vcftools_counts:
	input:
		"filtered_variantAndInvariant_{assembly}_{chromosome}.vcf.gz"
	output:
		"filtered_variantAndInvariant_{assembly}_{chromosome}.frq.count",
		"filtered_variantAndInvariant_{assembly}_{chromosome}.012",
		"filtered_variantAndInvariant_{assembly}_{chromosome}.012.indv",
		"filtered_variantAndInvariant_{assembly}_{chromosome}.012.pos"
	params:
		outPrefix="filtered_variantAndInvariant_{assembly}_{chromosome}"
	log:
		"logs/vcftools_counts/vcftools_counts_{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/vcftools.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	shell:
		"""
		# index vcf
		tabix {input}

		# output allele counts
		vcftools --gzvcf {input} --out {params.outPrefix} --counts2 &> {log}
		
		# output allele counts as a genotype matrix, useful for pairwise comparisons
		vcftools --gzvcf {input} --out {params.outPrefix} --012 &> {log}
		"""
