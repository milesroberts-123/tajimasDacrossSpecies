rule build_coding_kmer_database:
	input:
		"cds.fa"
	output:
		"codingKmerDatabase.txt"
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
		mkdir -p tmp_{params.outputPrefix}

		# count kmers
		kmc -k{params.kmerLength} -m16 -t{threads} -ci1 -cs1 -fm {input} {params.outputPrefix} tmp_{params.outputPrefix}

		# dump kmers to text file
		kmc_tools transform {params.outputPrefix} dump tmp_{output}

		# remove first column from text file
		cut -f1 tmp_{output} | sort > {output}

		# remove wd
		rm tmp_{output}
		rm -r tmp_codingKmerDatabase
		rm {params.outputPrefix}.kmc_pre
		rm {params.outputPrefix}.kmc_suf
		"""
