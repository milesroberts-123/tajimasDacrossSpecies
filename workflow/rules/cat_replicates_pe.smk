def get_pe_reps_one(wildcards):
	# extract replicates for concatenation
	runIDs = samples.loc[samples["replicate"] == wildcards.samplePe, "run"]
	return ["trimmed_reads/" + x + "_1_trim.fastq.gz" for x in runIDs]

def get_pe_reps_two(wildcards):
        # extract replicates for concatenation
        runIDs = samples.loc[samples["replicate"] == wildcards.samplePe, "run"]
        return ["trimmed_reads/" + x + "_2_trim.fastq.gz" for x in runIDs]

rule cat_replicates_pe:
	input: 
		read1=get_pe_reps_one,
		read2=get_pe_reps_two,
	output:
		read1=temp("cat_reads/{samplePe}_1_cat.fastq.gz"),
		read2=temp("cat_reads/{samplePe}_2_cat.fastq.gz"),
	log: 
		"logs/cat_replicates/{samplePe}.log"
	resources:
		mem_mb_per_cpu=4000
	shell:
		"""
		echo Concatenating read 1...
		zcat {input.read1} | gzip > {output.read1}

		echo Concatenating read 2...
		zcat {input.read2} | gzip > {output.read2}
		"""
