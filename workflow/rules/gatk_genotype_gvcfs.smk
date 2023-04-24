# need to split over multiple chromsomes
rule gatk_genotype_gvcfs:
	input:
		done="{assembly}_{chromosome}.done",
		genome="../config/assemblies/{assembly}.fa"
	output:
		vcf=temp("jointGenotypes_{assembly}_{chromosome}.vcf.gz"),
		tbi=temp("jointGenotypes_{assembly}_{chromosome}.vcf.gz.tbi")
	params:
		chromosome="{chromosome}"
	log:
		"logs/gatk_genotype_gvcfs/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=40000
	priority: 50
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		# using genomics database as input
		gatk --java-options "-Xmx32g" GenotypeGVCFs \
			-R {input.genome} \
			-V gendb://{wildcards.assembly}_{wildcards.chromosome}_database \
			--include-non-variant-sites \
			-L {params.chromosome} \
			-O {output.vcf} &> {log}
		
		# remove genomics database afterwards
		rm -r {wildcards.assembly}_{wildcards.chromosome}_database/
		"""
