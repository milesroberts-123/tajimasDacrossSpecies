def get_multiqc_input(wildcards):
        return ["fastp_output/" + x + "_se_fastp.json" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "run"])] + ["fastp_output/" + x + "_pe_fastp.json" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "run"])]

rule multiqc:
	input:
		get_multiqc_input
	output:
		"{assembly}_multiqc_report.html"
	log:
		"logs/multiqc/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	priority: 50
	conda:
		"../envs/multiqc.yml"
	shell:
		"""
		multiqc -f --filename {output} {input} &> {log}
		"""
