def get_se_reps(wildcards):
	# extract replicates for concatenation
	runIDs = samples.loc[samples["replicate"] == wildcards.sampleSe, "run"]
	return ["trimmed_reads/" + x + "_trim.fastq.gz" for x in runIDs]

rule cat_replicates_se:
	input: get_se_reps
	output:
		temp("cat_reads/{sampleSe}_cat.fastq.gz"),
	log: 
		"logs/cat_replicates/{sampleSe}.log"
	resources:
		mem_mb_per_cpu=4000
	shell:
		"zcat {input} | gzip > {output}"
