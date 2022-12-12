rule multiqc:
	input:
		expand("fastp_output/{runSe}_se_fastp.json", runSe=samplesSe.index.get_level_values("run")),
		expand("fastp_output/{runPe}_pe_fastp.json", runPe=samplesPe.index.get_level_values("run")),
	output:
		"multiqc_report.html"
	params:
		condaStatus=get_conda_status
	log:
		"logs/multiqc.log"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	conda:
		"../envs/multiqc.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 MultiQC/1.7-Python-3.6.6"
	shell:
		"""
		if [ "{params.condaStatus}" == "True" ]; then
                        echo Conda environment enabled
			echo "Multiqc installed in conda does not work because it cannot access a numpy umath module. Thus multiqc will not be run when --use-conda is True"
			echo Will create empty {output} file to avoid snakemake error
			touch {output}
		else
			echo Conda environment disabled
			echo Multiqc module on HPCC works so run multiqc
			multiqc -f --filename {output} fastp_output/ &> {log}
		fi
		"""
