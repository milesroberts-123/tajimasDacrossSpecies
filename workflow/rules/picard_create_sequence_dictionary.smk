rule picard_create_sequence_dictionary:
	input:
		"../config/assemblies/{assembly}.fa"
	output:
		"../config/assemblies/{assembly}.dict"
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
