rule fastp_pe:
	input:
		read1="raw_reads/{runPe}_1.fastq.gz",
		read2="raw_reads/{runPe}_2.fastq.gz"
	output:
		read1=temp("trimmed_reads/{runPe}_1_trim.fastq.gz"),
		read2=temp("trimmed_reads/{runPe}_2_trim.fastq.gz"),
		htmlReport=temp("fastp_output/{runPe}_fastp.html"),
		jsonReport=temp("fastp_output/{runPe}_pe_fastp.json")
	threads: 4
	resources:
		mem_mb_per_cpu=4000
	params:
		qualityScore=20,
		minReadLength=30,
		condaStatus=get_conda_status
	log:
		"logs/fastp/{runPe}.log"
	conda:
		"../envs/fastp.yml"
	shell:
		"""
		# if conda is enabled, use fastp conda env
		# if conda is disabled, check scripts for fastp binary
		if [ "{params.condaStatus}" == "True" ]; then		
			fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read1} -I {input.read2} -o {output.read1} -O {output.read2} &> {log}
		else
			scripts/fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read1} -I {input.read2} -o {output.read1} -O {output.read2} &> {log}
		fi
		"""
