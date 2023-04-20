rule create_genome_file:
	input:
		"genome.fa.fai"
	output:
		"genome.txt"
	shell:
		"awk -v OFS='\t' {'print $1,$2'} {input} > {output}"
