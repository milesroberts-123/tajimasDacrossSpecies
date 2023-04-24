rule separate_variant_invariant_sites:
	input:
		vcf="jointGenotypes_{assembly}_{chromosome}.vcf.gz",
		tbi="jointGenotypes_{assembly}_{chromosome}.vcf.gz.tbi"
	output:
		invariantSitesVCF=temp("invariant_{assembly}_{chromosome}.vcf.gz"),
		invariantSitesTBI=temp("invariant_{assembly}_{chromosome}.vcf.gz.tbi"),
		variantSitesVCF=temp("variant_{assembly}_{chromosome}.vcf.gz"),
		variantSitesTBI=temp("variant_{assembly}_{chromosome}.vcf.gz.tbi")
	log:
		"logs/separate_variant_invariant_sites/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		# invariant sites
		bcftools filter -e 'AC > 0' -o {output.invariantSites} -O z {input.vcf}
		tabix -f {output.invariantSitesVCF} # index sites
		
		# variant sites
		bcftools filter -i 'AC > 0' -o {output.variantSites} -O z {input.vcf}
		tabix -f {output.variantSitesVCF} # index sites
		"""
