rule download:
	output:
		temp("{sample}_1.fastq.gz"),
		temp("{sample}_2.fastq.gz")
	log:
		"logs/fastq-dump/{sample}.log"
	threads: 1
	envmodules:
		"SRA-Toolkit/2.10.7-centos_linux64"
	shell:
		"fastq-dump --gzip --split-e {wildcards.sample} &> {log}"
