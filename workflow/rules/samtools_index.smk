rule samtools_index:
	input:
		"sorted_marked_reads/{sample}.bam"
	output:
		"sorted_marked_reads/{sample}.bam.bai"
	log:
		"logs/samtools_index/{sample}.log"
	threads: 1
	envmodules:
		"GCC/9.3.0 SAMtools/1.11"
	shell:
		"samtools index {input} &> {log}"
