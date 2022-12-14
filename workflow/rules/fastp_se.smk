rule fastp_se:
	input:
		read="raw_reads/{runSe}.fastq.gz"
	output:
		read=temp("trimmed_reads/{runSe}_trim.fastq.gz"),
		htmlReport=temp("fastp_output/{runSe}_fastp.html"),
		jsonReport=temp("fastp_output/{runSe}_se_fastp.json")
	threads: 4
	resources:
		mem_mb_per_cpu=4000
	params:
		qualityScore=20,
		minReadLength=30,
		condaStatus=get_conda_status
	log:
		"logs/fastp/{runSe}.log"
	conda:
		"../envs/fastp.yml"
	shell:
		"""
		# if conda is enabled, use fastp conda env
                # if conda is disabled, check scripts for fastp binary
                if [ "{params.condaStatus}" == "True" ]; then
			fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read} -o {output.read} &> {log}
		else
			scripts/fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read} -o {output.read} &> {log}
		fi
		"""
