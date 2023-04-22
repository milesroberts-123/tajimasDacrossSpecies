# need to split over multiple chromsomes
rule gatk_genotype_gvcfs:
	input:
		done="{assembly}_{chromosome}.done",
		genome="../config/assemblies/{assembly}.fa"
	output:
		temp("jointGenotypes_{assembly}_{chromosome}.vcf.gz")
	log:
		"logs/gatk_genotype_gvcfs/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=50000
	conda:
		"../envs/gatk.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	shell:
		"""
		# using genomics database as input
		gatk --java-options "-Xmx32g" GenotypeGVCFs \
			-R {input.genome} \
			-V gendb://{wildcards.assembly}_{wildcards.chromosome}_database \
			-O {output} &> {log}
		
		# remove genomics database afterwards
		rm -r {wildcards.assembly}_{wildcards.chromosome}_database/
		"""
