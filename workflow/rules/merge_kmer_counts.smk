rule merge_kmer_counts:
	input:
		"kmerSubset.txt",
		expand("{sampleSe}_se_kmers.txt", sampleSe=samplesSe.index),
		expand("{samplePe}_pe_kmers.txt", samplePe=samplesPe.index)
	output:
		"bcd.txt"
	log:
		"logs/merge_kmer_counts.log"
	threads: get_thread_count
	resources:
		mem_mb_per_cpu=get_mem_mb
	envmodules:
		"iccifort/2019.5.281 impi/2018.5.288 R/4.0.0"
	shell:
		"Rscript scripts/merge_kmer_counts.R {input} {output} &> {log}"
