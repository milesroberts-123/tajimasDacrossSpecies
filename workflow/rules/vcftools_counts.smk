rule vcftools_counts:
	input:
		"filtered_variantAndInvariant_{chrom}.vcf.gz"
	output:
		"filtered_variantAndInvariant_{chrom}.frq.count",
		"filtered_variantAndInvariant_{chrom}.012",
		"filtered_variantAndInvariant_{chrom}.012.indv",
		"filtered_variantAndInvariant_{chrom}.012.pos"
	params:
		outPrefix="filtered_variantAndInvariant_{chrom}"
	log:
		"logs/vcftools_counts/vcftools_counts_{chrom}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
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
