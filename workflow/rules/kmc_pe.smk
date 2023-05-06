def get_kmer_database_files(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.samplePe, "genome"]
	genome = genome[0]
        return [genome + "_codingKmerDatabase.kmc_pre", genome + "_codingKmerDatabase.kmc_suf"]

def get_kmer_database_prefix(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.samplePe, "genome"]
        genome = genome[0]
	return genome + "_codingKmerDatabase"

rule kmc_pe:
	input:
		cdsDatabase=get_kmer_database_files,
		read1="cat_reads/{samplePe}_1_cat.fastq.gz",
		read2="cat_reads/{samplePe}_2_cat.fastq.gz"
	output:
		kmerCounts=temp("{samplePe}_pe_kmers.txt"),
		kmerDbPre=temp("nocds_{samplePe}_pe.kmc_pre"),
		kmerDbSuf=temp("nocds_{samplePe}_pe.kmc_suf")
	log:
		"logs/kmc_pe/{samplePe}.log"
	threads: 8
	params:
		kmerLength=config["kmerLength"],
		minKmerCount=1,
		maxKmerCount=1000000,
		cdsDbPrefix=get_kmer_database_prefix
	resources:
		mem_mb_per_cpu=5000
	conda:
		"../envs/kmc.yml"
	shell:
		"""
		# create working directory for kmc
		mkdir -p tmp_{wildcards.samplePe}

		# Count kmers for read1 and read2
		echo Counting kmers...
        	kmc -k{params.kmerLength} -m36 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read1} temporary1_{wildcards.samplePe} tmp_{wildcards.samplePe} &> {log}
        	kmc -k{params.kmerLength} -m36 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read2} temporary2_{wildcards.samplePe} tmp_{wildcards.samplePe} &>> {log}
        	
		# delete working directory
		rm -r tmp_{wildcards.samplePe}

		# Unionize kmer databases
        	echo Merging kmer databases...
        	kmc_tools simple temporary1_{wildcards.samplePe} temporary2_{wildcards.samplePe} union union_1_2_{wildcards.samplePe} &>> {log}

		# delete temporary databases after unionizing them
		rm temporary1_{wildcards.samplePe}.kmc_pre
		rm temporary1_{wildcards.samplePe}.kmc_suf
		rm temporary2_{wildcards.samplePe}.kmc_pre
		rm temporary2_{wildcards.samplePe}.kmc_suf
        	
		# subtract off k-mers found in coding sequences
		echo Removing CDS k-mers...
		kmc_tools simple union_1_2_{wildcards.samplePe} {params.cdsDbPrefix} kmers_subtract nocds_{wildcards.samplePe}_pe &>> {log}
 
		# No need to sort unionized kmer database, union function gives sorted output
        	# Dump to text file
        	echo Dumping kmers to text file...
        	kmc_tools transform nocds_{wildcards.samplePe}_pe dump {output.kmerCounts} &>> {log}

		# Delete temporary union
		rm union_1_2_{wildcards.samplePe}.kmc_pre
		rm union_1_2_{wildcards.samplePe}.kmc_suf
		"""
