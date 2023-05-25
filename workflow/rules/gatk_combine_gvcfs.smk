def get_calls(wildcards):
	return ["calls/" + x + "_se.g.vcf.gz" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])] + ["calls/" + x + "_pe.g.vcf.gz" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])]

def get_tbis(wildcards):
	return ["calls/" + x + "_se.g.vcf.gz.tbi" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])] + ["calls/" + x + "_pe.g.vcf.gz.tbi" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])]

# need to somehow split rule over multiple chromsomes
# in shell command, use bash brace expansion to add a -V flag to each input file
rule gatk_combine_gvcfs:
	input:
		calls = get_calls,
		tbis = get_tbis,
		genome="../config/assemblies/{assembly}.fa"
	output:
		temp("{assembly}_{chromosome}.done")
	params:
		chromosome="{chromosome}"
	log:
		"logs/gatk_combine_gvcfs/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=24000
	conda:
		"../envs/gatk.yml"
	shell:
		"""
		# Check if output directory exists already. If so, delete it
		if [ -d "tmp_{wildcards.assembly}_{wildcards.chromosome}/" ]
		then
			echo Deleting temporary directory from previous run...  &> {log}
			rm -r tmp_{wildcards.assembly}_{wildcards.chromosome}/
		fi

		# Check if genomics db already exists. If so, delete it
		# enabling overwriting doesn't resolve error for some reason
		if [ -d "{wildcards.assembly}_{wildcards.chromosome}_database/" ]
		then
			echo Deleting genomics db from previous run... &> {log}
			rm -rf {wildcards.assembly}_{wildcards.chromosome}_database/
		fi

		# make temporary directory
		mkdir -p tmp_{wildcards.assembly}_{wildcards.chromosome}

		# run import step
		gatk --java-options "-Xmx8g -Xms8g" GenomicsDBImport $(echo {input.calls} | sed 's/calls/-V calls/g') \
		--batch-size 50 \
		--reader-threads {threads} \
		--overwrite-existing-genomicsdb-workspace \
		--genomicsdb-workspace-path {wildcards.assembly}_{wildcards.chromosome}_database \
		--tmp-dir=tmp_{wildcards.assembly}_{wildcards.chromosome}/ \
		-L {params.chromosome} &> {log}

		# remove temporary directory
		rm -r tmp_{wildcards.assembly}_{wildcards.chromosome}

		# I don't know which file to define as the output for this function for snakemake because a whole directory of outputs is created
		# I'm just gonna create an empty temporary file that is made when GenomicsDBImport completes
		touch {output}
		"""
