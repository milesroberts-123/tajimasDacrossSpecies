rule kmc_se:
	input:
		"filtered_reads/{sampleSe}_filt.fastq",
	output:
		temp("{sampleSe}_se_kmers.txt")
	log:
		"logs/kmc_se/{sampleSe}.log"
	threads: 8
	params:
		kmerLength=30,
		minKmerCount=1,
		maxKmerCount=2000000 # should be double the max for counting in paired-end samples so that single-end and paired-end samples can achieve the same max k-mer count
	resources:
		mem_mb_per_cpu=2000
	envmodules:
		"GCC/10.3.0 KMC/3.1.2rc1-Python-3.9.5"
	shell:
		"""
		# create working directory for kmc
		mkdir -p tmp_{wildcards.sampleSe}

		# Count kmers
		echo Counting kmers...
		kmc -k{params.kmerLength} -m16 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input} temporary_{wildcards.sampleSe} tmp_{wildcards.sampleSe} &> {log}
        	
		# Sort kmer databases
		echo Sorting kmer databases...
		kmc_tools transform temporary_{wildcards.sampleSe} sort sorted_{wildcards.sampleSe} &>> {log}

		# Dump to text file
		echo Dumping kmers to text file...
		kmc_tools transform sorted_{wildcards.sampleSe} dump {output} &>> {log}
		
		# remove working directory, temporary files
		rm -r tmp_{wildcards.sampleSe}
		rm sorted_{wildcards.sampleSe}.kmc_pre
		rm sorted_{wildcards.sampleSe}.kmc_suf
		rm temporary_{wildcards.sampleSe}.kmc_pre
		rm temporary_{wildcards.sampleSe}.kmc_suf
		"""
