def get_multiqc_input(wildcards):
        return ["fastp_output/" + x + "_se_fastp.json" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "run"])] + ["fastp_output/" + x + "_pe_fastp.json" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "run"])]

rule multiqc:
	input:
		#expand("fastp_output/{runSe}_se_fastp.json", runSe=samplesSe.index.get_level_values("run")),
		#expand("fastp_output/{runPe}_pe_fastp.json", runPe=samplesPe.index.get_level_values("run")),
		get_multiqc_input
	output:
		"{assembly}_multiqc_report.html"
	log:
		"logs/multiqc/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	conda:
		"../envs/multiqc.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 MultiQC/1.7-Python-3.6.6"
	shell:
		"""
		multiqc -f --filename {output} {input} &> {log}
		"""
