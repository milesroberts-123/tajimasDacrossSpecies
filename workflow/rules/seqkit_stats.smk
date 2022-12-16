rule seqkit_stats:
	input:
		expand("raw_reads/{runSe}.fastq.gz", runSe=samplesSe.index.get_level_values("run")),
                expand("raw_reads/{runPe}_{end}.fastq.gz", runPe=samplesPe.index.get_level_values("run"), end = [1,2])		
	output:
		"readStats.txt"
	log:
		"logs/seqkit_stats.log"
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
			seqkit stats -j {threads} {input} > {output}
		else
			scripts/seqkit stats -j {threads} {input} > {output}
		fi
		"""
