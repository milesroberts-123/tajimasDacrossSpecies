rule samtools_sort:
	input:
		"mapped_reads/{sample}.bam"
	output:
		temp("sorted_reads/{sample}.bam")
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	conda:
		"../envs/samtools.yml"
	shell:
		"samtools sort -T sorted_reads/{wildcards.sample} "
		"-O bam {input} > {output}"
