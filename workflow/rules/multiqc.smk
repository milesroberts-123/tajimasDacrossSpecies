rule multiqc:
	input:
		expand("fastp_output/{sampleSe}_se_fastp.json", sampleSe=samplesSe.index),
		expand("fastp_output/{samplePe}_pe_fastp.json", samplePe=samplesPe.index),
	output:
		"multiqc_report.html"
	log:
		"logs/multiqc.log"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 MultiQC/1.7-Python-3.6.6"
	shell:
		"multiqc --filename multiqc_report.html fastp_output/ &> {log}"
