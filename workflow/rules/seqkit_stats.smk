def get_se_reads(wildcards):
	seRuns = samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "run"]
	return ["raw_reads/" + str(x) + ".fastq.gz" for x in seRuns]

def get_pe_reads(wildcards):
	peRuns = samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "run"]
	return ["raw_reads/" + str(x) + "_1" + ".fastq.gz" for x in peRuns] + ["raw_reads/" + str(x) + "_2" + ".fastq.gz" for x in peRuns]

rule seqkit_stats:
	input:
		seRuns = get_se_reads,
                peRuns = get_pe_reads		
	output:
		"{assembly}_readStats.txt"
	log:
		"logs/seqkit_stats/{assembly}.log"
	threads: 4
        resources:
                mem_mb_per_cpu=4000
	params:
		condaStatus=get_conda_status
	conda:
		"../envs/seqkit.yml"
	shell:
		"""
		# if conda is enabled, use seqkit conda env
                # if conda is disabled, check scripts for seqkit binary
                if [ "{params.condaStatus}" == "True" ]; then
			seqkit stats -j {threads} {input.seRuns} {input.peRuns} > {output}
		else
			scripts/seqkit stats -j {threads} {input.seRuns} {input.peRuns} > {output}
		fi
		"""
