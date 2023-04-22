rule build_coding_kmer_database:
	input:
		"{assembly}_cds.fa"
	output:
		kmcDbPre=temp("{assembly}_codingKmerDatabase.kmc_pre"),
		kmcDbSuf=temp("{assembly}_codingKmerDatabase.kmc_suf")
	log:
		"logs/build_coding_kmer_database/{assembly}.log"
	threads: 4
	params:
		kmerLength=config["kmerLength"],
		outputPrefix="{assembly}_codingKmerDatabase"
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
		# -cs needs to be 2, because a value of 1 is not supported in the conda environment for some reason
		kmc -k{params.kmerLength} -m16 -t{threads} -ci1 -cs2 -fm {input} {params.outputPrefix} tmp_{params.outputPrefix}

		# remove intermediate files
		rm -r tmp_{params.outputPrefix}
		"""
