rule get_cds_seq:
	input:
		fasta="../config/assemblies/{assembly}.fa",
		gff="../config/annotations/{assembly}.gff3"
	output:
		faOut = temp("{assembly}_cds.fa"),
		gffOut = temp("{assembly}_cds.gff")
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
		awk '(($3 == "CDS"))' {input.gff} > {output.gffOut}
		
		# extract CDS from fasta
		bedtools getfasta -fi {input.fasta} -bed {output.gffOut} > {output.faOut}
		"""
