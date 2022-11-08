rule kmc_tools_filter_pe:
	input:
		read1="trimmed_reads/{samplePe}_1_trim.fastq.gz",
		read2="trimmed_reads/{samplePe}_2_trim.fastq.gz",
		prefix="codingKmerDatabase.kmc_pre",
		suffix="codingKmerDatabase.kmc_suf"
	output:
		read1="filtered_reads/{samplePe}_1_filt.fastq.gz",
		read2="filtered_reads/{samplePe}_2_filt.fastq.gz"
	log:
		"logs/kmc_tools_filter_se/{samplePe}.log"
	params:
		databasePrefix="codingKmerDatabase"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	envmodules:
		"GCC/10.3.0 KMC/3.1.2rc1-Python-3.9.5"
	shell:
		"""
		kmc_tools filter {params.databasePrefix} {input.read1} -cx1 {output.read1}
		kmc_tools filter {params.databasePrefix} {input.read2} -cx1 {output.read2}
		"""
