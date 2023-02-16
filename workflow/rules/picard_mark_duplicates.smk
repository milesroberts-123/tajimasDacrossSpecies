rule picard_mark_duplicates:
	input:
		"sorted_reads/{sample}.bam"
	output:
		markedDups=temp("sorted_marked_reads/{sample}.bam"),
		dupMetrics="markedDups/{sample}.txt"
	params:
		condaStatus=get_conda_status
	envmodules:
		"picard/2.22.1-Java-11"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	log:
		"logs/picard_mark_duplicates/{sample}.log"
	conda:
		"../envs/picard.yml"
	shell:
		"""
		if [ "{params.condaStatus}" == "True" ]; then
                        echo Conda environment enabled, using conda-specific command
			picard -Xmx32g MarkDuplicates I={input} O={output.markedDups} M={output.dupMetrics} &> {log}
		else
			echo Conda environment disabled, using HPCC-specific command
			java -Xmx32g -jar $EBROOTPICARD/picard.jar MarkDuplicates I={input} O={output.markedDups} M={output.dupMetrics} &> {log}
		fi
		"""
