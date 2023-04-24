rule samtools_index:
	input:
		"sorted_marked_reads/{sample}.bam"
	output:
		"sorted_marked_reads/{sample}.bam.bai"
	log:
		"logs/samtools_index/{sample}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	conda:
		"../envs/samtools.yml"
	shell:
		"samtools index {input} &> {log}"
