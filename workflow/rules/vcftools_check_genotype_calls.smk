rule vcftools_check_genotype_calls:
	input:
		"jointGenotypes_{chrom}.vcf.gz"
	output:
		"out_{chrom}.frq",
                "out_{chrom}.ldepth.mean",
                "out_{chrom}.lqual",
                "out_{chrom}.lmiss"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	threads: 1
	log:
		"logs/vcftools_check_genotype_calls/vcftools_check_genotype_calls_{chrom}.log"
	shell:
		"""
		# allele frequencies, used to distinguish variant from invariant
		vcftools --gzvcf {input} --freq2 &> {log}

		# site mean depth
		vcftools --gzvcf {input} --site-mean-depth &> {log}

		# site quality
		vcftools --gzvcf {input} --site-quality &> {log}

		# proportion missing data per site
		vcftools --gzvcf {input} --missing-site &> {log}
		"""
