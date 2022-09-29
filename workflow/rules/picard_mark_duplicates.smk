rule picard_mark_duplicates:
	input:
		"sorted_reads/{sample}.bam"
	output:
		markedDups=temp("sorted_marked_reads/{sample}.bam"),
		dupMetrics="markedDups/{sample}.txt"
	envmodules:
		"picard/2.22.1-Java-11"
	threads: 1
	log:
		"logs/picard_mark_duplicates/{sample}.log"
	shell:
		"""
		java -jar $EBROOTPICARD/picard.jar MarkDuplicates \
      			I={input} \
			O={output.markedDups} \
			M={output.dupMetrics} &> {log}
		"""
