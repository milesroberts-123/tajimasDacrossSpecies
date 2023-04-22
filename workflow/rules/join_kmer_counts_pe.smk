def get_kmer_key_pe(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.samplePe, "genome"]
        genome = genome[0]
	return genome + "_kmerRandomSubset.txt"

rule join_kmer_counts_pe:
	input:
		key=get_kmer_key_pe,
		kmerCounts="{samplePe}_pe_kmers.txt"
	output:
		temp("{samplePe}_pe_mergedKmerCounts.txt")
	log:
		"logs/join_kmer_counts_pe/{samplePe}.log"
	threads: 1
	priority: 50
	resources:
		mem_mb_per_cpu=8000
	shell:
		"""
		# join kmer counts with random k-mer subset
		join -j 1 -a 1 -e "0" -o auto {input.key} {input.kmerCounts} 1> {output} 2> {log}
		"""
