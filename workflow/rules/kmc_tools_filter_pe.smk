rule kmc_tools_filter_pe:
	input:
		read1="trimmed_reads/{samplePe}_1_trim.fastq.gz",
		read2="trimmed_reads/{samplePe}_2_trim.fastq.gz",
		kmcDatabase="codingKmerDatabase"
	output:
		read1="filtered_reads/{samplePe}_1_filt.fastq.gz",
		read2="filtered_reads/{samplePe}_2_filt.fastq.gz"
	log:
		"logs/kmc_tools_filter_se/{samplePe}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	shell:
		"""
		kmc_tools filter {input.kmcDatabase} {input.read1} -cx1 {output.read1}
		kmc_tools filter {input.kmcDatabase} {input.read2} -cx1 {output.read2}
		"""
