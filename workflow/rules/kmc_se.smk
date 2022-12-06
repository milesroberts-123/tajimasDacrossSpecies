rule kmc_se:
	input:
		cdsDatabase="codingKmerDatabase.txt",
		read="trimmed_reads/{sampleSe}_trim.fastq.gz"
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
	conda:
		"../envs/kmc.yml"
	envmodules:
		"GCC/10.3.0 KMC/3.1.2rc1-Python-3.9.5"
	shell:
		"""
		# create working directory for kmc
		mkdir -p tmp_{wildcards.sampleSe}

		# Count kmers
		echo Counting kmers...
		kmc -k{params.kmerLength} -m16 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read} temporary_{wildcards.sampleSe} tmp_{wildcards.sampleSe} &> {log}
        	
		# Sort kmer databases
		echo Sorting kmer databases...
		kmc_tools transform temporary_{wildcards.sampleSe} sort sorted_{wildcards.sampleSe} &>> {log}

		# Dump to text file
		echo Dumping kmers to text file...
		kmc_tools transform sorted_{wildcards.sampleSe} dump raw_{output} &>> {log}

		# create temp list of k-mers in sample
                cut -f1 raw_{output} > tmp_{output}

                # find k-mers in sample that do not match coding sequences
                echo Finding k-mers in sample that do not match coding sequences...
                comm -13 {input.cdsDatabase} tmp_{output} > uniq_{output}

                # subset just k-mers that aren't in coding sequence database
                join uniq_{output} raw_{output} > {output}
		
		# remove working directory, temporary files
		rm -r tmp_{wildcards.sampleSe}
		rm sorted_{wildcards.sampleSe}.kmc_pre
		rm sorted_{wildcards.sampleSe}.kmc_suf
		rm temporary_{wildcards.sampleSe}.kmc_pre
		rm temporary_{wildcards.sampleSe}.kmc_suf
		#rm raw_{output}
		#rm tmp_{output}
		#rm uniq_{output}
		"""
