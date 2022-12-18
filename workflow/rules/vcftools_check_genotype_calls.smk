rule vcftools_check_genotype_calls:
	input:
		"jointGenotypes_{assembly}_{chromosome}.vcf.gz"
	output:
		"out_{assembly}_{chromosome}.frq",
                "out_{assembly}_{chromosome}.ldepth.mean",
                "out_{assembly}_{chromosome}.lqual",
                "out_{assembly}_{chromosome}.lmiss"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	threads: 1
        resources:
                mem_mb_per_cpu=8000
	conda:
		"../envs/vcftools.yml"
	log:
		"logs/vcftools_check_genotype_calls/vcftools_check_genotype_calls_{assembly}_{chromosome}.log"
	shell:
		"""
		# allele frequencies, used to distinguish variant from invariant
		vcftools --gzvcf {input} --out out_{wildcards.assembly}_{wildcards.chromosome} --freq2 &> {log}

		# site mean depth
		vcftools --gzvcf {input} --out out_{wildcards.assembly}_{wildcards.chromosome} --site-mean-depth &> {log}

		# site quality
		vcftools --gzvcf {input} --out out_{wildcards.assembly}_{wildcards.chromosome} --site-quality &> {log}

		# proportion missing data per site
		vcftools --gzvcf {input} --out out_{wildcards.assembly}_{wildcards.chromosome} --missing-site &> {log}
		"""
