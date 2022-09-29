rule fastp:
	input:
		read1="{sample}_1.fastq.gz",
		read2="{sample}_2.fastq.gz"
	output:
		read1=temp("trimmed_reads/{sample}_1_trim.fastq.gz"),
		read2=temp("trimmed_reads/{sample}_2_trim.fastq.gz"),
		htmlReport="fastp_output/{sample}_fastp.html",
		jsonReport="fastp_output/{sample}_fastp.json"
	threads: 4
	params:
		qualityScore=20,
		minReadLength=25
	log:
		"logs/fastp/{sample}.log"
	shell:
		"scripts/fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read1} -I {input.read2} -o {output.read1} -O {output.read2} &> {log}"
