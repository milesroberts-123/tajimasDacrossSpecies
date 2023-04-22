def get_kmer_key_se(wildcards):
        genome = samples.loc[samples["replicate"] == wildcards.sampleSe, "genome"]
	genome = genome[0]
        return genome + "_kmerRandomSubset.txt"

rule join_kmer_counts_se:
	input:
		key=get_kmer_key_se,
		kmerCounts="{sampleSe}_se_kmers.txt"
	output:
		temp("{sampleSe}_se_mergedKmerCounts.txt")
	log:
		"logs/join_kmer_counts_se/{sampleSe}_join_kmer_counts.log"
	threads: 1
	priority: 50
	resources:
		mem_mb_per_cpu=8000
	shell:
		"""
		# join kmer counts with random k-mer subset
		join -j 1 -a 1 -e "0" -o auto {input.key} {input.kmerCounts} 1> {output} 2> {log}
		"""
