rule cbind_kmer_counts:
	input:
		key="kmerRandomSubset.txt",
		kmerCounts=expand("{sampleSe}_se_mergedKmerCounts.txt", sampleSe=samplesSe.index) + expand("{samplePe}_pe_mergedKmerCounts.txt", samplePe=samplesPe.index)
	output:
		"mergedKmerCounts.txt"
	log:
		"logs/cbind_kmer_counts.log"
	threads: 1
	resources:
		mem_mb_per_cpu = 16000
	shell:
		"""
		# paste in k-mer key to first column, save as bash script
		echo "paste <(cut -f1 {input.key}) \" > myScript.sh

		# write code to paste in kmer counts
		echo {input.kmerCounts}| sed 's/^/<(cut -f2 /' | sed 's/.txt/.txt) <(cut -f2/g' | sed 's/<(cut -f2$//' >> myScript.sh
		
		# make script executable
		chmod +x myScript.sh

		# run script
		./myScript.sh 1> {output} 2> {log}	
		"""
