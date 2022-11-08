rule kmc_pe:
	input:
		read1="filtered_reads/{samplePe}_1_filt.fastq.gz",
		read2="filtered_reads/{samplePe}_2_filt.fastq.gz"
	output:
		"{samplePe}_pe_kmers.txt"
	log:
		"logs/kmc_pe/{samplePe}.log"
	threads: 8
	params:
		kmerLength=25,
		minKmerCount=1,
		maxKmerCount=100
	resources:
		mem_mb_per_cpu=2000
	envmodules:
		"GCC/10.3.0 KMC/3.1.2rc1-Python-3.9.5"
	shell:
		"""
		# create working directory for kmc
		mkdir tmp_{wildcards.samplePe}

		# Count kmers for read1 and read2
        	echo Counting kmers...
        	kmc -k{params.kmerLength} -m16 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read1} temporary1_{wildcards.samplePe} tmp_{wildcards.samplePe}
        	kmc -k{params.kmerLength} -m16 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read2} temporary2_{wildcards.samplePe} tmp_{wildcards.samplePe}
        	
		# Unionize kmer databases
        	echo Merging kmer databases...
        	kmc_tools simple temporary1_{wildcards.samplePe} temporary2_{wildcards.samplePe} union union_1_2_{wildcards.samplePe}
        	
		# No need to sort unionized kmer database, union function gives sorted output
        	# Dump to text file
        	echo Dumping kmers to text file...
        	kmc_tools transform union_1_2_{wildcards.samplePe} dump {output}
		
		# delete working directory
		rm -r tmp_{wildcards.samplePe}
		"""