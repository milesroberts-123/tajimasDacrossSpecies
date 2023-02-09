rule download_gbif:
	output:
		"{species}_areas.txt"
	log:
		"logs/download_gbif/{species}.log"
	conda:
		"../envs/download_gbif.yml"
	envmodules:
		"GCC/11.2.0 OpenMPI/4.1.1 R/4.2.2"
	threads: 1
	resources:
		mem_mb_per_cpu=4000
	shell:
		"Rscript scripts/download_gbif.R {wildcards.species} &> {log}"
