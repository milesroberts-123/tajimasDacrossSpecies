rule degenotate:
	input:
		genome="data/genome.fa",
		annot="data/genome.gff3"
	output:
		"data/fourfoldDegenerateSites.bed"
	log:
		"logs/degenotate.log"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	shell:
		"""
		# remove lengthy titles so fasta headers match gff exactly
		# replace ambiguous bases with N
		#scripts/seqkit replace -s -p [^ATGC] -r N {input.genome} | scripts/seqkit replace -p " .*" -r "" > data/genome_shortTitles_noAmbig.fa
 
		# run degenotate, remove any extra information in fasta header after initial key
		scripts/degenotate/degenotate.py -d " " -a {input.annot} -g {input.genome} -o data/degenotateOutput
		
		# subset out four-fold degenerate sites
		awk '(($5 == 4))' data/degenotateOutput/degeneracy-all-sites.bed > {output}
		"""
