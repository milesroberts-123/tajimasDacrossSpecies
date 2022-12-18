def get_genome(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.sampleSe, "genome"]
        return "data/assemblies/" + genome + ".fa"

rule bwa_mem_pe:
	input:
		bwaIndex=multiext(get_genome, ".amb", ".ann", ".bwt", ".pac", ".sa"),
		genome="data/assemblies/{assembly}.fa",
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
	envmodules:
		"GCC/5.4.0-2.26 OpenMPI/1.10.3 BWA/0.7.17 GCCcore/9.3.0 SAMtools/1.11"
	shell:
		"(bwa mem -R '{params.rg}' -t {threads} {input.genome} {input.read1} {input.read2} | "
		"samtools view -Sb - > {output}) 2> {log}"
