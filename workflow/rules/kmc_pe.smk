rule kmc_pe:
	input:
		cdsDatabase="codingKmerDatabase.txt",
		read1="trimmed_reads/{samplePe}_1_trim.fastq.gz",
		read2="trimmed_reads/{samplePe}_2_trim.fastq.gz"
	output:
		temp("{samplePe}_pe_kmers.txt")
	log:
		"logs/kmc_pe/{samplePe}.log"
	threads: 8
	params:
		kmerLength=30,
		minKmerCount=1,
		maxKmerCount=1000000
	resources:
		mem_mb_per_cpu=2000
	conda:
		"../envs/kmc.yml"
	envmodules:
		"GCC/10.3.0 KMC/3.1.2rc1-Python-3.9.5"
	shell:
		"""
		# create working directory for kmc
		mkdir -p tmp_{wildcards.samplePe}

		# Count kmers for read1 and read2
		echo Counting kmers...
        	kmc -k{params.kmerLength} -m16 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read1} temporary1_{wildcards.samplePe} tmp_{wildcards.samplePe} &> {log}
        	kmc -k{params.kmerLength} -m16 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read2} temporary2_{wildcards.samplePe} tmp_{wildcards.samplePe} &>> {log}
        	
		# Unionize kmer databases
        	echo Merging kmer databases...
        	kmc_tools simple temporary1_{wildcards.samplePe} temporary2_{wildcards.samplePe} union union_1_2_{wildcards.samplePe} &>> {log}
        	
		# No need to sort unionized kmer database, union function gives sorted output
        	# Dump to text file
        	echo Dumping kmers to text file...
        	kmc_tools transform union_1_2_{wildcards.samplePe} dump raw_{output} &>> {log}
		
		# create temp list of k-mers in sample
		cut -f1 raw_{output} > tmp_{output}

		# find k-mers in sample that do not match coding sequences
		echo Finding k-mers in sample that do not match coding sequences...
		comm -13 {input.cdsDatabase} tmp_{output} > uniq_{output}

		# subset just k-mers that aren't in coding sequence database
		join uniq_{output} raw_{output} > {output}

		# delete working directory, temporary files
		rm -r tmp_{wildcards.samplePe}
		rm temporary1_{wildcards.samplePe}.kmc_pre
		rm temporary1_{wildcards.samplePe}.kmc_suf
		rm temporary2_{wildcards.samplePe}.kmc_pre
		rm temporary2_{wildcards.samplePe}.kmc_suf
		rm union_1_2_{wildcards.samplePe}.kmc_pre
		rm union_1_2_{wildcards.samplePe}.kmc_suf
		#rm raw_{output}
		#rm tmp_{output}
		#rm uniq_{output}
		"""
