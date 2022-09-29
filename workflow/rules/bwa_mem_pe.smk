rule bwa_mem_pe:
	input:
		bwaIndex1="data/genome.fa.amb",
                bwaIndex2="data/genome.fa.ann",
                bwaIndex3="data/genome.fa.bwt",
                bwaIndex4="data/genome.fa.pac",
                bwaIndex5="data/genome.fa.sa",
        	genome="data/genome.fa",
        	read1="trimmed_reads/{samplePe}_1_trim.fastq.gz",
		read2="trimmed_reads/{samplePe}_2_trim.fastq.gz"
	output:
		temp("mapped_reads/{samplePe}_pe.bam")
	params:
		rg=r"@RG\tID:{samplePe}\tSM:{samplePe}"
	log:
		"logs/bwa_mem/{samplePe}.log"
	threads: 8
	envmodules:
		"GCC/5.4.0-2.26 OpenMPI/1.10.3 BWA/0.7.17 GCCcore/9.3.0 SAMtools/1.11"
	shell:
		"(bwa mem -R '{params.rg}' -t {threads} {input.genome} {input.read1} {input.read2} | "
		"samtools view -Sb - > {output}) 2> {log}"
