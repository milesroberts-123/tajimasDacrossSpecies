rule collect_reps:
	input: expand("cat_reads/{rep}_trim.fastq.gz", rep=samples.index.get_level_values('replicate'))
