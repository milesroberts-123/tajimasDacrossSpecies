rule samtools_faidx:
	input:
		"data/assemblies/{assembly}.fa"
	output:
		index="data/assemblies/{assembly}.fa.fai",
		genomeFile="data/assemblies/{assembly}.txt"
	log:
		"logs/samtools_faidx/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	conda:
		"../envs/samtools.yml"
	envmodules:
		"GCC/9.3.0 SAMtools/1.11"
	shell:
		"""
		# index genome
		samtools faidx {input} &> {log}
		# create genome file for bedtools
		awk -v OFS='\t' {{'print $1,$2'}} {output.index} > {output.genomeFile}
		"""
