rule picard_create_sequence_dictionary:
	input:
		"data/genome.fa"
	output:
		"data/genome.dict"
	envmodules:
		"picard/2.22.1-Java-11"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	log:
		"logs/picard_create_sequence_dictionary.log"
	shell:
		"""
		java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary \
			R={input} \
			O={output} &> {log}
		"""
