rule cbind_kmer_counts:
	input:
		key="{assembly}_kmerRandomSubset.txt",
		#kmerCounts=expand("{sampleSe}_se_mergedKmerCounts.txt", sampleSe=set(samplesSe.index.get_level_values("replicate"))) + expand("{samplePe}_pe_mergedKmerCounts.txt", samplePe=set(samplesPe.index.get_level_values("replicate")))
		kmerCounts=expand("{sample}_se_mergedKmerCounts.txt", sample=set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])) + expand("{sample}_pe_mergedKmerCounts.txt", sample=set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"]))
	output:
		matrix="{assembly}_mergedKmerCounts.txt",
		cbindScript="{assembly}_cbind.sh"
	log:
		"logs/cbind_kmer_counts/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu = 16000
	shell:
		"""
		# Extract file names and create header for merged matrix
		HEADER=$(echo "kmer {input.kmerCounts}" | sed 's/_se_mergedKmerCounts.txt//g' | sed 's/_pe_mergedKmerCounts.txt//g') 
		echo $HEADER > {assembly}_headers.txt

		# paste in k-mer key to first column, save as bash script
		echo 'paste -d " " {input.key} \\' > {output.cbindScript}

		# write code to paste in kmer counts
		echo {input.kmerCounts}| sed 's/^/<(cut -d" " -f2 /' | sed 's/.txt/.txt) <(cut -d" " -f2/g' | sed 's/<(cut -d" " -f2$//' >> {output.cbindScript}
		
		# make script executable
		chmod +x {output.cbindScript}

		# run script
		./{output.cbindScript} 1> {output.matrix} 2> {log}

		# Add header to output
		# sed -i '1i "$HEADER"' {output.matrix}
		cat {assembly}_headers.txt {output.matrix} > {assembly}_tmpMyMatrix
		mv {assembly}_tmpMyMatrix {output.matrix}
		"""
