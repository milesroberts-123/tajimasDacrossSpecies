rule gatk_variant_filtration_invariant_sites:
	input:
		genome="data/genome.fa",
		invariantSites="invariant_{chrom}.vcf.gz"
	output:
		temp("annotated_invariant_{chrom}.vcf.gz")
	log:
		"logs/gatk_variant_filtration_invariant_sites/gatk_variant_filtration_invariant_sites_{chrom}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	shell:
		"""
		gatk VariantFiltration \
			-R {input.genome} \
			-O {output} \
			-V {input.invariantSites} \
			--filter-name "QUALabove100" \
			--filter-expression "QUAL > 100.0" &> {log}
		"""
