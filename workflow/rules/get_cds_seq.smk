rule get_cds_seq:
	input:
		fasta="data/assemblies/{assembly}.fa",
		gff="data/annotations/{assembly}.gff3"
	output:
		"{assembly}_cds.fa"
	log:
		"logs/get_cds_seq/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=750
	conda:
		"../envs/bedtools.yml"
	envmodules:
		"GCC/10.2.0 BEDTools/2.30.0"
	shell:
		"""
		# subset gff to just CDS
		awk '(($3 == "CDS"))' {input.gff} > cds.gff
		
		# extract CDS from fasta
		bedtools getfasta -fi {input.fasta} -bed cds.gff > {output}
		"""
