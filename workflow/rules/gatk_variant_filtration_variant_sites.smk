rule gatk_variant_filtration_variant_sites:
	input:
		genome="data/genome.fa",
		variantSites="variant_{chrom}.vcf.gz"
	output:
		temp("annotated_variant_{chrom}.vcf.gz")
	log:
		"logs/gatk_variant_filtration_variant_sites/gatk_variant_filtration_variant_sites_{chrom}.log"
	threads: 1
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	shell:
		"""
		gatk VariantFiltration \
			-R {input.genome} \
			-O {output} \
			-V {input.variantSites} \
			--filter-name "QD2" \
			--filter-expression "QD < 2.0" \
			--filter-name "QUAL30" \
			--filter-expression "QUAL < 30.0" \
			--filter-name "MQ40" \
			--filter-expression "MQ < 40.00" \
			--filter-name "FS60" \
			--filter-expression "FS > 60.0" \
			--filter-name "HaplotypeScore13" \
			--filter-expression "HaplotypeScore > 13.0" \
			--filter-name "MQRankSum" \
			--filter-expression "MQRankSum < -12.5" \
			--filter-name "ReadPosRankSum" \
			--filter-expression "ReadPosRankSum < -8.0" &> {log}
		"""
