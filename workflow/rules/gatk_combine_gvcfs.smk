def get_calls(wildcards):
	return ["calls/" + x + "_se.g.vcf.gz" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])] + ["calls/" + x + "_pe.g.vcf.gz" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])]

# need to somehow split rule over multiple chromsomes
# in shell command, use bash brace expansion to add a -V flag to each input file
rule gatk_combine_gvcfs:
	input:
		#calls=expand("calls/{sample}_se.g.vcf.gz", sample=set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])) + expand("calls/{sample}_pe.g.vcf.gz", sample=set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])),
		calls = get_calls,
		genome="data/assemblies/{assembly}.fa"
	output:
		temp("combinedCalls_{assembly}_{chromosome}.g.vcf.gz")		
	params:
		chromosome="{chromosome}"
	log:
		"logs/gatk_combine_gvcfs/{assembly}_{chromosome}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=20000
	conda:
		"../envs/gatk.yml"
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	shell:
		"""
		gatk CombineGVCFs \
		-R {input.genome} $(echo {input.calls} | sed 's/calls/-V calls/g') \
		-L {params.chromosome} \
		-O {output} &> {log}
		"""
