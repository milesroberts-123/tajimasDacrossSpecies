rule subset_genome:
	input:
		gff="data/genome.gff3",
		genomeFile="data/genome.txt"
	output:
		"data/regions.bed"
	threads: 1
	envmodules:
		"GCC/8.3.0 BEDTools/2.29.2"
	shell:
		"scripts/subset_genome.bash -g {input.gff} -G {input.genomeFile} -b {output}"
	
