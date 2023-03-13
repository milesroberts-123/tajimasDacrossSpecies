rule bwa_index:
	input:
		"data/assemblies/{assembly}.fa"
	output:
		"data/assemblies/{assembly}.fa.amb",
		"data/assemblies/{assembly}.fa.ann",
		"data/assemblies/{assembly}.fa.bwt",
		"data/assemblies/{assembly}.fa.pac",
		"data/assemblies/{assembly}.fa.sa"
	log:
		"logs/bwa_index/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	conda:
		"../envs/bwa_mem.yml"
	envmodules:
		"GCC/5.4.0-2.26 OpenMPI/1.10.3 BWA/0.7.17"
	shell:
		"bwa index {input} &> {log}"
