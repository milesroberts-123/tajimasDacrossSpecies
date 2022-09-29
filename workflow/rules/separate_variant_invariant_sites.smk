rule separate_variant_invariant_sites:
	input:
		"jointGenotypes_{chrom}.vcf.gz"
	output:
		invariantSites=temp("invariant_{chrom}.vcf.gz"),
		variantSites=temp("variant_{chrom}.vcf.gz")
	log:
		"logs/separate_variant_invariant_sites/separate_variant_invariant_sites_{chrom}.log"
	threads: 1
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	shell:
		"""
		# invariant sites
		vcftools --gzvcf {input} \
			--max-maf 0 \
			--recode --stdout | bgzip -c > {output.invariantSites}

		tabix {output.invariantSites} # index sites
		
		# variant sites
		vcftools --gzvcf {input} \
			--mac 1 \
			--recode --stdout | bgzip -c > {output.variantSites}

		tabix {output.variantSites} # index sites
		"""
