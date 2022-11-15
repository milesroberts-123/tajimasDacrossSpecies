rule build_coding_kmer_database:
	input:
		"cds.fa"
	output:
		"codingKmerDatabase.kmc_pre",
		"codingKmerDatabase.kmc_suf"
	log:
		"logs/build_coding_kmer_database.log"
	threads: 4
	params:
		kmerLength=30,
		outputPrefix="codingKmerDatabase"
	resources:
		mem_mb_per_cpu=4000
	conda:
		"../envs/kmc.yml"
	envmodules:
                "GCC/10.3.0 KMC/3.1.2rc1-Python-3.9.5"
	shell:
		"""
		# create wd, but remove it first if it already exists
		mkdir -p tmp_codingKmerDatabase

		# count kmers
		kmc -k{params.kmerLength} -m16 -t{threads} -ci1 -cs1 -fm {input} {params.outputPrefix} tmp_codingKmerDatabase

		# remove wd
		rm -r tmp_codingKmerDatabase
		"""
