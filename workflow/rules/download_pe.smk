rule download_pe:
	output:
		temp("raw_reads/{runPe}_1.fastq.gz"),
		temp("raw_reads/{runPe}_2.fastq.gz")
	log:
		"logs/fastq-dump/{runPe}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	conda:
		"../envs/download.yml"
	shell:
		"""
		# download data
		fastq-dump --gzip --split-e {wildcards.runPe} &> {log}
		
		# move data to folder
		mv {wildcards.runPe}_1.fastq.gz raw_reads/
		mv {wildcards.runPe}_2.fastq.gz raw_reads/
		"""
