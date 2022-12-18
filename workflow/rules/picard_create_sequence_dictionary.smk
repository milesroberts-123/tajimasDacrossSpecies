rule picard_create_sequence_dictionary:
	input:
		"data/assemblies/{assembly}.fa"
	output:
		"data/assemblies/{assembly}.dict"
	params:
		condaStatus=get_conda_status
	envmodules:
		"picard/2.22.1-Java-11"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	log:
		"logs/picard_create_sequence_dictionary/{assembly}.log"
	conda:
		"../envs/picard.yml"
	shell:
		"""
		if [ "{params.condaStatus}" == "True" ]; then
			echo Conda environment enabled, using conda-specific command
			picard CreateSequenceDictionary R={input} O={output} &> {log}
		else
			echo Conda environment disabled, using HPCC-specific command
			java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary R={input} O={output} &> {log}
		fi
		"""
