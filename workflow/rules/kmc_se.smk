def get_kmer_database_files(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.sampleSe, "genome"]
	genome = genome[0]
        return [genome + "_codingKmerDatabase.kmc_pre", genome + "_codingKmerDatabase.kmc_suf"]

def get_kmer_database_prefix(wildcards):
	genome = samples.loc[samples["replicate"] == wildcards.sampleSe, "genome"]
	genome = genome[0]
	return genome + "_codingKmerDatabase"

rule kmc_se:
	input:
		cdsDatabase=get_kmer_database_files,
		read="cat_reads/{sampleSe}_cat.fastq.gz"
	output:
		kmerCounts=temp("{sampleSe}_se_kmers.txt"),
		kmerDbPre=temp("nocds_{sampleSe}_se.kmc_pre"),
		kmerDbSuf=temp("nocds_{sampleSe}_se.kmc_suf")
	log:
		"logs/kmc_se/{sampleSe}.log"
	threads: 8
	params:
		cdsDbPrefix=get_kmer_database_prefix,
		kmerLength=config["kmerLength"],
		minKmerCount=1,
		maxKmerCount=2000000 # should be double the max for counting in paired-end samples so that single-end and paired-end samples can achieve the same max k-mer count
	resources:
		mem_mb_per_cpu=2000
	conda:
		"../envs/kmc.yml"
	shell:
		"""
		# create working directory for kmc
		mkdir -p tmp_{wildcards.sampleSe}

		# Count kmers
		echo Counting kmers...
		kmc -k{params.kmerLength} -m16 -t{threads} -ci{params.minKmerCount} -cs{params.maxKmerCount} {input.read} temporary_{wildcards.sampleSe} tmp_{wildcards.sampleSe} &> {log}
		
		# delete working directory
		rm -r tmp_{wildcards.sampleSe}
        	
		# Sort kmer databases
		echo Sorting kmer databases...
		kmc_tools transform temporary_{wildcards.sampleSe} sort sorted_{wildcards.sampleSe} &>> {log}
		
		# delete unsorted k-mer count database
		rm temporary_{wildcards.sampleSe}.kmc_pre
		rm temporary_{wildcards.sampleSe}.kmc_suf

		# subtract off k-mers found in coding sequences
		echo Removing CDS k-mers...
		kmc_tools simple sorted_{wildcards.sampleSe} {params.cdsDbPrefix} kmers_subtract nocds_{wildcards.sampleSe}_se &>> {log}

		# Dump to text file
		echo Dumping kmers to text file...
		kmc_tools transform nocds_{wildcards.sampleSe}_se dump {output.kmerCounts} &>> {log}

		# delete sorted database after text file is made
		rm sorted_{wildcards.sampleSe}.kmc_pre
		rm sorted_{wildcards.sampleSe}.kmc_suf
		"""
