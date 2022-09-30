# need to somehow split rule over multiple chromsomes
# in shell command, use bash brace expansion to add a -V flag to each input file
rule gatk_combine_gvcfs:
	input:
		calls=expand("calls/{sample}_se.g.vcf.gz", sample=samplesSe.index) + expand("calls/{sample}_pe.g.vcf.gz", sample=samplesPe.index),
		genome="data/genome.fa"
	output:
		temp("combinedCalls_{chrom}.g.vcf.gz")		
	params:
		chromosome="{chrom}"
	log:
		"logs/gatk_combine_gvcfs/gatk_combine_gvcfs_{chrom}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=20000
	envmodules:
		"GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6"
	shell:
		"gatk CombineGVCFs -R {input.genome} $(echo {input.calls} | sed 's/calls/-V calls/g') -L {params.chromosome} -O {output} &> {log}"
