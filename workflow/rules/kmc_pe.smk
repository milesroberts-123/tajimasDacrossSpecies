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
		kmerLength=30,
		minKmerCount=1,
		maxKmerCount=1000000,
		cdsDbPrefix=get_kmer_database_prefix
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
		kmc_tools simple union_1_2_{wildcards.samplePe} {params.cdsDbPrefix} kmers_subtract nocds_{wildcards.samplePe} &>> {log}
 
		# No need to sort unionized kmer database, union function gives sorted output
        	# Dump to text file
        	echo Dumping kmers to text file...
        	kmc_tools transform nocds_{wildcards.samplePe} dump {output.kmerCounts} &>> {log}

		# Delete temporary union
		rm union_1_2_{wildcards.samplePe}.kmc_pre
		rm union_1_2_{wildcards.samplePe}.kmc_suf
		
		# create temp list of k-mers in sample
		# cut -f1 raw_{output} > tmp_{output}

		# find k-mers in sample that do not match coding sequences
		# echo Finding k-mers in sample that do not match coding sequences...
		# comm -13 {input.cdsDatabase} tmp_{output} > uniq_{output}

		# delete temporary k-mer list
		# rm tmp_{output}

		# subset just k-mers that aren't in coding sequence database
		# join -t $'\t' uniq_{output} raw_{output} > {output}

		# delete temporary files that give final output
		# rm raw_{output}
		# rm uniq_{output}
		"""
