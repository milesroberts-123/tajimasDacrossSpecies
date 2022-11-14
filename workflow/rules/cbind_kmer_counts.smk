rule cbind_kmer_counts:
	input:
		key="kmerRandomSubset.txt",
		kmerCounts=expand("{sampleSe}_se_mergedKmerCounts.txt", sampleSe=samplesSe.index) + expand("{samplePe}_pe_mergedKmerCounts.txt", samplePe=samplesPe.index)
	output:
		matrix="mergedKmerCounts.txt",
		cbindScript="cbind.sh"
	log:
		"logs/cbind_kmer_counts.log"
	threads: 1
	resources:
		mem_mb_per_cpu = 16000
	shell:
		"""
		# Extract file names and create header for merged matrix
		HEADER=$(echo "kmer {input.kmerCounts}" | sed 's/_se_mergedKmerCounts.txt//g' | sed 's/_pe_mergedKmerCounts.txt//g') 

		# paste in k-mer key to first column, save as bash script
		echo 'paste <(cut -f1 {input.key}) \\' > {output.cbindScript}

		# write code to paste in kmer counts
		echo {input.kmerCounts}| sed 's/^/<(cut -f2 /' | sed 's/.txt/.txt) <(cut -f2/g' | sed 's/<(cut -f2$//' >> {output.cbindScript}
		
		# make script executable
		chmod +x {output.cbindScript}

		# run script
		./{output.cbindScript} 1> {output.matrix} 2> {log}

		# Add header to output
		sed -i '1i "$HEADER"' {output.matrix}
		"""
