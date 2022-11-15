rule gatk_haplotype_caller:
	input:
		index="data/genome.fa.fai",
		dictionary="data/genome.dict",
		genome="data/genome.fa",
		reads="sorted_marked_reads/{sample}.bam",
		readsIndex="sorted_marked_reads/{sample}.bam.bai",
		regions="data/fourfoldDegenerateSites.bed"
	output:
		temp("calls/{sample}.g.vcf.gz")
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	threads: 4
	resources:
		mem_mb_per_cpu=4000
	conda:
		"../envs/gatk.yml"
	log:
		"logs/gatk_haplotype_caller/{sample}.log"
	shell:
		"""
		gatk HaplotypeCaller \
			-R {input.genome} \
			-I {input.reads} \
			-O {output} \
			-L {input.regions} \
			-ERC GVCF \
			--native-pair-hmm-threads {threads} \
			--sample-ploidy 2 \
			--heterozygosity 0.001 \
			--indel-heterozygosity 0.001 \
			--min-base-quality-score 20 &> {log}
		"""
