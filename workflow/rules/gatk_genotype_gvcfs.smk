# need to split over multiple chromsomes
rule gatk_genotype_gvcfs:
	input:
		allCalls="combinedCalls_{chrom}.g.vcf.gz",
		genome="data/genome.fa"
	output:
		temp("jointGenotypes_{chrom}.vcf.gz")
	log:
		"logs/gatk_genotype_gvcfs/gatk_genotype_gvcfs_{chrom}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=50000
	conda:
		"../envs/gatk.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	shell:
		"""
		gatk GenotypeGVCFs \
   			-R {input.genome} \
   			-V {input.allCalls} \
   			-O {output} \
   			--include-non-variant-sites &> {log}
		
		# remove temp index
		rm combinedCalls_{wildcards.chrom}.g.vcf.gz.tbi
		"""
