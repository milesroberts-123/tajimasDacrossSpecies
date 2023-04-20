rule picard_create_sequence_dictionary:
	input:
		"data/assemblies/{assembly}.fa"
	output:
		"data/assemblies/{assembly}.dict"
	envmodules:
		"picard/2.22.1-Java-11"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	log:
		"logs/picard_create_sequence_dictionary/{assembly}.log"
	conda:
		"../envs/picard.yml"
	shell:
		"""
		picard -Xmx16G CreateSequenceDictionary R={input} O={output} &> {log}
		"""
