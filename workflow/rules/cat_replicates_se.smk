def get_se_reps(wildcards):
	# extract replicates for concatenation
	runIDs = samples.loc[samples["replicate"] == wildcards.sampleSe, "run"]
	return ["trimmed_reads/" + x + "_trim.fastq.gz" for x in runIDs]

rule cat_replicates_se:
	input: get_se_reps
	output:
		"cat_reads/{sampleSe}_cat.fastq.gz",
	params:
	log: "log/cat_replicates/{sampleSe}.log"
	shell:
		"cat {input} > {output}"
