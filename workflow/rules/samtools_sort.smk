rule samtools_sort:
	input:
		"mapped_reads/{sample}.bam"
	output:
		temp("sorted_reads/{sample}.bam")
	threads: 8
	resources:
		mem_mb_per_cpu=2000
	conda:
		"../envs/samtools.yml"
	shell:
		"samtools sort -@ {threads} -T sorted_reads/{wildcards.sample} "
		"-O bam {input} > {output}"
