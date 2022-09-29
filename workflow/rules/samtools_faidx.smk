rule samtools_faidx:
	input:
		"data/genome.fa"
	output:
		index="data/genome.fa.fai",
		genomeFile="data/genome.txt"
	log:
		"logs/samtools_faidx.log"
	threads: 1
	envmodules:
		"GCC/9.3.0 SAMtools/1.11"
	shell:
		"""
		# index genome
		samtools faidx {input} &> {log}
		# create genome file for bedtools
		awk -v OFS='\t' {{'print $1,$2'}} {output.index} > {output.genomeFile}
		"""
