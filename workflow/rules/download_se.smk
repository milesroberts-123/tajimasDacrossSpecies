rule download_se:
	input:
		"data/samples.tsv"
	output:
		temp("raw_reads/{runSe}.fastq.gz"),
	log:
		"logs/fastq-dump/{runSe}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=1500
	conda:
		"../envs/download.yml"
	envmodules:
		"SRA-Toolkit/2.10.7-centos_linux64"
	shell:
		"""
		# download data
		fastq-dump --gzip --split-e {wildcards.runSe} &> {log}
		
		# move data into folder to help organization
		mv {wildcards.runSe}.fastq.gz raw_reads/
		"""
