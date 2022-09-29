rule samtools_sort:
	input:
		"mapped_reads/{sample}.bam"
	output:
		temp("sorted_reads/{sample}.bam")
	threads: 1
	envmodules:
		"GCC/9.3.0 SAMtools/1.11"
	shell:
		"samtools sort -T sorted_reads/{wildcards.sample} "
		"-O bam {input} > {output}"
