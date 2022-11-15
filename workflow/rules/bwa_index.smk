rule bwa_index:
	input:
		"data/genome.fa"
	output:
		"data/genome.fa.amb",
		"data/genome.fa.ann",
		"data/genome.fa.bwt",
		"data/genome.fa.pac",
		"data/genome.fa.sa"
	log:
		"logs/bwa_index.log"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	conda:
		"../envs/bwa_mem.yml"
	envmodules:
		"GCC/5.4.0-2.26 OpenMPI/1.10.3 BWA/0.7.17"
	shell:
		"bwa index {input} &> {log}"
