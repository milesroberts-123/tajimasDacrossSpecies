def get_genome(wildcards):
	genome = samples.loc[samples["replicate"] == wildcards.sampleSe, "genome"]
	return "data/assemblies/" + genome + ".fa"


def get_index(wildcards):
	genome = samples.loc[samples["replicate"] == wildcards.sampleSe, "genome"]
	return ["data/assemblies/" + genome + ".fa" + x for x in [".amb", ".ann", ".bwt", ".pac", ".sa"]]


rule bwa_mem_se:
	input:
		genome=get_genome,
		bwaIndices=get_index,
		read="cat_reads/{sampleSe}_cat.fastq.gz",
	output:
		temp("mapped_reads/{sampleSe}_se.bam")
	params:
		rg=r"@RG\tID:{sampleSe}\tSM:{sampleSe}"
	log:
		"logs/bwa_mem/{sampleSe}.log"
	threads: 8
	resources:
		mem_mb_per_cpu=2000
	conda:
		"../envs/bwa_mem.yml"
	envmodules:
		"GCC/5.4.0-2.26 OpenMPI/1.10.3 BWA/0.7.17 GCCcore/9.3.0 SAMtools/1.11"
	shell:
		"(bwa mem -R '{params.rg}' -t {threads} {input.genome} {input.read} | "
		"samtools view -Sb - > {output}) 2> {log}"
