rule samtools_faidx:
	input:
		"../config/assemblies/{assembly}.fa"
	output:
		index="../config/assemblies/{assembly}.fa.fai",
	log:
		"logs/samtools_faidx/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	conda:
		"../envs/samtools.yml"
	shell:
		"""
		# index genome
		samtools faidx {input} &> {log}
		"""
