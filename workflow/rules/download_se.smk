rule download_se:
	output:
		temp("raw_reads/{runSe}.fastq.gz"),
	log:
		"logs/fastq-dump/{runSe}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	conda:
		"../envs/download.yml"
	shell:
		"""
		# download data
		fastq-dump --gzip --split-e {wildcards.runSe} &> {log}
		
		# move data into folder to help organization
		mv {wildcards.runSe}.fastq.gz raw_reads/
		"""
