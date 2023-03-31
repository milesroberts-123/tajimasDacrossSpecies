def get_ploidy(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        ploidy = samples.loc[samples["replicate"] == repName, "ploidy"]
        ploidy = ploidy[0]
        return int(ploidy)

def get_genome(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        genome = samples.loc[samples["replicate"] == repName, "genome"]
	genome = genome[0]
        return "data/assemblies/" + str(genome) + ".fa"

def get_dict(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        genome = samples.loc[samples["replicate"] == repName, "genome"]
	genome = genome[0]
        return "data/assemblies/" + str(genome) + ".dict"

def get_fai(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        genome = samples.loc[samples["replicate"] == repName, "genome"]
	genome = genome[0]
        return "data/assemblies/" + str(genome) + ".fa.fai"

def get_regions(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        genome = samples.loc[samples["replicate"] == repName, "genome"]
	genome = genome[0]
        return "data/" + str(genome) + "_fourfoldDegenerateSites.bed"

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
	params:
		ploidy=get_ploidy
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	threads: 4
	priority: 25
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
			--sample-ploidy {params.ploidy} \
			--heterozygosity 0.001 \
			--indel-heterozygosity 0.001 \
			--min-base-quality-score 20 &> {log}
		"""
