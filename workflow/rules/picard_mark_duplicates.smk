rule picard_mark_duplicates:
	input:
		"sorted_reads/{sample}.bam"
	output:
		markedDups=temp("sorted_marked_reads/{sample}.bam"),
		dupMetrics="markedDups/{sample}.txt"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	log:
		"logs/picard_mark_duplicates/{sample}.log"
	conda:
		"../envs/picard.yml"
	shell:
		"""
		picard -Xmx24g MarkDuplicates I={input} O={output.markedDups} M={output.dupMetrics} &> {log}
		"""
