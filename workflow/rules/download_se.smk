rule download_se:
	input:
		"data/samples_se.tsv"
	output:
		temp("{sampleSe}.fastq.gz"),
	log:
		"logs/fastq-dump/{sampleSe}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=750
	conda:
		"envs/download.yml"
	envmodules:
		"SRA-Toolkit/2.10.7-centos_linux64"
	shell:
		"fastq-dump --gzip --split-e {wildcards.sampleSe} &> {log}"
