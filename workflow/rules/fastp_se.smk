rule fastp_se:
	input:
		read="{sampleSe}.fastq.gz"
	output:
		read=temp("trimmed_reads/{sampleSe}_trim.fastq.gz"),
		htmlReport=temp("fastp_output/{sampleSe}_fastp.html"),
		jsonReport=temp("fastp_output/{sampleSe}_se_fastp.json")
	threads: 4
	resources:
		mem_mb_per_cpu=4000
	params:
		qualityScore=20,
		minReadLength=30
	log:
		"logs/fastp/{sampleSe}.log"
	conda:
		"envs/fastp.yml"
	shell:
		"fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read} -o {output.read} &> {log}"
