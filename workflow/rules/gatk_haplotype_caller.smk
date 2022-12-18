def get_genome(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.sample, "genome"]
        return "data/assemblies/" + genome + ".fa"

def get_dict(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.sample, "genome"]
        return "data/assemblies/" + genome + ".dict"

def get_fai(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.sample, "genome"]
        return "data/assemblies/" + genome + ".fa.fai"

def get_regions(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.sample, "genome"]
        return "data/" + genome + "_fourfoldDegenerateSites.bed"

rule gatk_haplotype_caller:
	input:
		index=get_fai,
		dictionary=get_dict,
		genome=get_genome,
		regions=get_regions,
		reads="sorted_marked_reads/{sample}.bam",
		readsIndex="sorted_marked_reads/{sample}.bam.bai",
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
