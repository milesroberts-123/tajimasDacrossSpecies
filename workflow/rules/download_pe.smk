rule download_pe:
	input:
		"data/samples_pe.tsv"
	output:
		temp("{samplePe}_1.fastq.gz"),
		temp("{samplePe}_2.fastq.gz")
	log:
		"logs/fastq-dump/{samplePe}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=750
	conda:
		"../envs/download.yml"
	envmodules:
		"SRA-Toolkit/2.10.7-centos_linux64"
	shell:
		"fastq-dump --gzip --split-e {wildcards.samplePe} &> {log}"
