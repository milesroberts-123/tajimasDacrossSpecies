rule fastp_se:
	input:
		read="{sampleSe}.fastq.gz"
	output:
		read=temp("trimmed_reads/{sampleSe}_trim.fastq.gz"),
		htmlReport=temp("fastp_output/{sampleSe}_fastp.html"),
		jsonReport=temp("fastp_output/{sampleSe}_se_fastp.json")
	threads: 4
	params:
		qualityScore=20,
		minReadLength=25
	log:
		"logs/fastp/{sampleSe}.log"
	shell:
		"scripts/fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read} -o {output.read} &> {log}"
