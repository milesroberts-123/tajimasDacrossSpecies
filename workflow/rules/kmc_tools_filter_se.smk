rule kmc_tools_filter_se:
	input:
		read="trimmed_reads/{sampleSe}_trim.fastq.gz",
		kmcDatabase="codingKmerDatabase"
	output:
		"filtered_reads/{sampleSe}_filt.fastq.gz"
	log:
		"logs/kmc_tools_filter_se/{sampleSe}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=8000
	shell:
		"kmc_tools filter {input.kmcDatabase} {input.read} -cx1 {output}"
