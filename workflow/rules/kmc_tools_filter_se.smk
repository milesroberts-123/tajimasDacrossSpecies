rule kmc_tools_filter_se:
	input:
		read="trimmed_reads/{sampleSe}_trim.fastq.gz",
		prefix="codingKmerDatabase.kmc_pre",
		suffix="codingKmerDatabase.kmc_suf"
	output:
		temp("filtered_reads/{sampleSe}_filt.fastq")
	log:
		"logs/kmc_tools_filter_se/{sampleSe}.log"
	params:
		databasePrefix="codingKmerDatabase"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
        conda:
                "../envs/kmc.yml"
	envmodules:
		"GCC/10.3.0 KMC/3.1.2rc1-Python-3.9.5"
	shell:
		"""
		# filter reads by kmers
		kmc_tools filter {params.databasePrefix} {input.read} -cx10 {output} &> {log}
		"""
