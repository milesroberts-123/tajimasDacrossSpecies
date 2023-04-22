rule separate_variant_invariant_sites:
	input:
		"jointGenotypes_{assembly}_{chromosome}.vcf.gz"
	output:
		invariantSites=temp("invariant_{assembly}_{chromosome}.vcf.gz"),
		variantSites=temp("variant_{assembly}_{chromosome}.vcf.gz")
	log:
		"logs/separate_variant_invariant_sites/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	conda:
		"../envs/bcftools.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0"
	shell:
		"""
		# invariant sites
		bcftools filter -e 'AC > 0' -o {output.invariantSites} -O z {input}
		tabix {output.invariantSites} # index sites
		
		# variant sites
		bcftools filter -i 'AC > 0' -o {output.variantSites} -O z {input}
		tabix {output.variantSites} # index sites
		
		# remove temporary indices
		rm {input}.tbi
		"""
