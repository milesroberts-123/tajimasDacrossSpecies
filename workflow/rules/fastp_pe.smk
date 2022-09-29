rule fastp_pe:
	input:
		read1="{samplePe}_1.fastq.gz",
		read2="{samplePe}_2.fastq.gz"
	output:
		read1=temp("trimmed_reads/{samplePe}_1_trim.fastq.gz"),
		read2=temp("trimmed_reads/{samplePe}_2_trim.fastq.gz"),
		htmlReport=temp("fastp_output/{samplePe}_fastp.html"),
		jsonReport=temp("fastp_output/{samplePe}_pe_fastp.json")
	threads: 4
	params:
		qualityScore=20,
		minReadLength=25
	log:
		"logs/fastp/{samplePe}.log"
	shell:
		"scripts/fastp --dont_eval_duplication --thread {threads} -q {params.qualityScore} -l {params.minReadLength} -h {output.htmlReport} -j {output.jsonReport} -i {input.read1} -I {input.read2} -o {output.read1} -O {output.read2} &> {log}"
