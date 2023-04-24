def get_genome(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.samplePe, "genome"]
	genome = genome[0]
        return "../config/assemblies/" + str(genome) + ".fa"

def get_index(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.samplePe, "genome"]
	genome = genome[0]
        return ["../config/assemblies/" + str(genome) + ".fa." + str(x) for x in ["amb", "ann", "bwt", "pac", "sa"]]

rule bwa_mem_pe:
	input:
		genome=get_genome,
		bwaIndices=get_index,
		read1="cat_reads/{samplePe}_1_cat.fastq.gz",
		read2="cat_reads/{samplePe}_2_cat.fastq.gz"
	output:
		temp("mapped_reads/{samplePe}_pe.bam")
	params:
		rg=r"@RG\tID:{samplePe}\tSM:{samplePe}"
	log:
		"logs/bwa_mem/{samplePe}.log"
	threads: 8
	resources:
		mem_mb_per_cpu=2000
	conda:
		"../envs/bwa_mem.yml"
	shell:
		"(bwa mem -R '{params.rg}' -t {threads} {input.genome} {input.read1} {input.read2} | "
		"samtools view -Sb - > {output}) 2> {log}"
