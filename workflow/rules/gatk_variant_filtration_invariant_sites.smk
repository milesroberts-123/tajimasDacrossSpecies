rule gatk_variant_filtration_invariant_sites:
	input:
		genome="../config/assemblies/{assembly}.fa",
		invariantSitesVCF="invariant_{assembly}_{chromosome}.vcf.gz",
		invariantSitesTBI="invariant_{assembly}_{chromosome}.vcf.gz.tbi"
	output:
		gzvcf=temp("annotated_invariant_{assembly}_{chromosome}.vcf.gz"),
		tbi=temp("annotated_invariant_{assembly}_{chromosome}.vcf.gz.tbi")
	log:
		"logs/gatk_variant_filtration_invariant_sites/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		gatk VariantFiltration \
			-R {input.genome} \
			-O {output.gzvcf} \
			-V {input.invariantSitesVCF} \
			--filter-name "QUALabove100" \
			--filter-expression "QUAL > 100.0" &> {log}
		"""
