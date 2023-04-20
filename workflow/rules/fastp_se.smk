rule fastp_se:
	input:
		read="raw_reads/{runSe}.fastq.gz"
	output:
		read=temp("trimmed_reads/{runSe}_trim.fastq.gz"),
		htmlReport=temp("fastp_output/{runSe}_fastp.html"),
		jsonReport=temp("fastp_output/{runSe}_se_fastp.json")
	threads: 8
	priority: 50
	resources:
		mem_mb_per_cpu=5000
	params:
		qualityScore=20,
		minReadLength=30
	log:
		"logs/fastp/{runSe}.log"
	conda:
		"../envs/fastp.yml"
	shell:
		"""		
		fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read} -o {output.read} &> {log}
		"""
