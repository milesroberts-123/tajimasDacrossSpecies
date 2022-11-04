rule build_coding_kmer_database:
	input:
		"cds.fa"
	output:
		"codingKmerDatabase"
	log:
		"logs/build_coding_kmer_database.log"
	threads: 1
	params:
		kmerLength=25
	resources:
		mem_mb_per_cpu=1000
	shell:
		"""
		# create wd
		mkdir tmp_codingKmerDatabase

		# count kmers
		kmc -k{params.kmerLength} -m16 -t{threads} -ci1 -cs1 -fm {input} {output} tmp_codingKmerDatabase

		# remove wd
		rm -r tmp_codingKmerDatabase
		"""
