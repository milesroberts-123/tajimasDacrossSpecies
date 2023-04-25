def get_ploidy(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        ploidy = samples.loc[samples["replicate"] == repName, "ploidy"]
        ploidy = ploidy[0]
        return int(ploidy)

def get_genome(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        genome = samples.loc[samples["replicate"] == repName, "genome"]
	genome = genome[0]
        return "../config/assemblies/" + str(genome) + ".fa"

def get_dict(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        genome = samples.loc[samples["replicate"] == repName, "genome"]
	genome = genome[0]
        return "../config/assemblies/" + str(genome) + ".dict"

def get_fai(wildcards):
	repName = re.sub("_pe|_se", "", wildcards.sample)
        genome = samples.loc[samples["replicate"] == repName, "genome"]
	genome = genome[0]
        return "../config/assemblies/" + str(genome) + ".fa.fai"

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
		vcf=temp("calls/{sample}.g.vcf.gz"),
		tbi=temp("calls/{sample}.g.vcf.gz.tbi")
	params:
		ploidy=get_ploidy,
		het = config["het"],
		qualityScore = config["qualityScore"]
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
			-O {output.vcf} \
			-L {input.regions} \
			-ERC GVCF \
			--native-pair-hmm-threads {threads} \
			--sample-ploidy {params.ploidy} \
			--heterozygosity {params.het} \
			--indel-heterozygosity {params.het} \
			--min-base-quality-score {params.qualityScore} &> {log}
		"""
