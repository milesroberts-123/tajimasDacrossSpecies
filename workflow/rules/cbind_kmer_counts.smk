def get_cbind_kmer_counts_input(wildcards):
	return [x + "_se_mergedKmerCounts.txt" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])] + [x + "_pe_mergedKmerCounts.txt" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])]

rule cbind_kmer_counts:
	input:
		key="{assembly}_kmerRandomSubset.txt",
		kmerCounts=get_cbind_kmer_counts_input
	output:
		matrix="{assembly}_AllMergedKmerCounts.txt",
		cbindScript=temp("{assembly}_cbind.sh")
	log:
		"logs/cbind_kmer_counts/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu = 16000
	shell:
		"""
		# Extract file names and create header for merged matrix
		HEADER=$(echo "kmer {input.kmerCounts}" | sed 's/_se_mergedKmerCounts.txt//g' | sed 's/_pe_mergedKmerCounts.txt//g') 
		echo $HEADER > {wildcards.assembly}_headers.txt

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
		cat {wildcards.assembly}_headers.txt {output.matrix} > {wildcards.assembly}_tmpMyMatrix
		mv {wildcards.assembly}_tmpMyMatrix {output.matrix}
		"""
