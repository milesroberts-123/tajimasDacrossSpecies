rule bwa_index:
	input:
		"../config/assemblies/{assembly}.fa"
	output:
		"../config/assemblies/{assembly}.fa.amb",
		"../config/assemblies/{assembly}.fa.ann",
		"../config/assemblies/{assembly}.fa.bwt",
		"../config/assemblies/{assembly}.fa.pac",
		"../config/assemblies/{assembly}.fa.sa"
	log:
		"logs/bwa_index/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	conda:
		"../envs/bwa_mem.yml"
	shell:
		"bwa index {input} &> {log}"
