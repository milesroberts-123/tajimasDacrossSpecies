def get_taxon_key(wildcards):
        taxon_key = species.loc[species["species"] == wildcards.species, "taxonKey"]
        return taxon_key

envvars:
	"GBIF_EMAIL",
	"GBIF_USER",
	"GBIF_PWD"

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
		mem_mb_per_cpu=4000,
	params:
		taxonKey = get_taxon_key,
		gbifEmail=os.environ["GBIF_EMAIL"],
		gbifUser=os.environ["GBIF_USER"],
		gbifPwd=os.environ["GBIF_PWD"]
	shell:
		"Rscript scripts/download_gbif.R {wildcards.species} {params.taxonKey} {params.gbifUser} {params.gbifEmail} {params.gbifPwd} &> {log}"
