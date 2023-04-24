def get_taxon_keys(wildcards):
        taxon_keys = samples.loc[samples["genome"] == wildcards.assembly, "taxonKeys"]
	taxon_keys = taxon_keys[0]
        return taxon_keys

envvars:
	"GBIF_EMAIL",
	"GBIF_USER",
	"GBIF_PWD"

rule download_gbif:
	output:
		"{assembly}_areas.txt"
	log:
		"logs/download_gbif/{assembly}.log"
	conda:
		"../envs/download_gbif.yml"
	threads: 1
	resources:
		mem_mb_per_cpu=4000,
		load = 1
	params:
		occCountThreshold = 20,
		taxonKeys = get_taxon_keys,
		gbifEmail=os.environ["GBIF_EMAIL"],
		gbifUser=os.environ["GBIF_USER"],
		gbifPwd=os.environ["GBIF_PWD"]
	shell:
		"Rscript scripts/download_gbif.R {wildcards.assembly} {params.gbifUser} {params.gbifEmail} {params.gbifPwd} {params.occCountThreshold} {params.taxonKeys} &> {log}"
