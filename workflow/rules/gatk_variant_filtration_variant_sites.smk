rule gatk_variant_filtration_variant_sites:
	input:
		genome="../config/assemblies/{assembly}.fa",
		variantSitesVCF="variant_{assembly}_{chromosome}.vcf.gz",
		variantSitesTBI="variant_{assembly}_{chromosome}.vcf.gz.tbi"
	output:
		finalvcf = temp("annotated_variant_{assembly}_{chromosome}.vcf.gz"),
		finaltbi = temp("annotated_variant_{assembly}_{chromosome}.vcf.gz.tbi"),
		nanfixed = temp("variant_{assembly}_{chromosome}_NaN.vcf.gz"),
		nanfixedindex = temp("variant_{assembly}_{chromosome}_NaN.vcf.gz.tbi")
	log:
		"logs/gatk_variant_filtration_variant_sites/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		# convert nan values to NaN if they are present
		# issue this fixes: https://github.com/broadinstitute/gatk/issues/5582
		bcftools view {input.variantSitesVCF} | sed 's/=nan/=NaN/g'  | bgzip > {output.nanfixed}
		tabix -f {output.nanfixed}

		# filter variants
		gatk VariantFiltration \
			-R {input.genome} \
			-O {output.finalvcf} \
			-V {output.nanfixed} \
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
