rule join_kmer_counts:
	input:
		key="kmerSubset.txt",
		kmerCounts=expand("{sampleSe}_se_kmers.txt", sampleSe=samplesSe.index) + expand("{samplePe}_pe_kmers.txt", samplePe=samplesPe.index)
	output:
		"mergedKmerCounts.txt"
	log:
		"logs/join_kmer_counts.log"
	threads: 1
	resources:
		mem_mb_per_cpu=64000
	shell:
		"""
		# build header for merged kmer matrix
		echo {input.key} {input.kmerCounts} | sed 's/_se_kmers.txt//g' | sed 's/_pe_kmers.txt//g' | sed 's/Subset.txt//' > {output}

		# build large join command and output join command to a script
		echo {input.kmerCounts} | sed 's/ / | join -j 1 -a 1 -e "0" -o auto - /g' | sed 's/$/ >> {output}/' | sed 's/^/join -j 1 -a 1 -e "0" -o auto {input.key} /' > myScript.sh
		
		# make join command executable
		chmod +x myScript.sh

		# execute join script
		./myScript.sh
		
		# delete join script once it's complete
		rm myScript.sh
		"""
