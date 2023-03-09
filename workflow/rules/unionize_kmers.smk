def get_list_kmers_input(wildcards):
	return ["nocds_" + x + "_pe.kmc_pre" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])] + ["nocds_" + x + "_pe.kmc_suf" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])] + ["nocds_" + x + "_se.kmc_pre" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])] + ["nocds_" + x + "_se.kmc_suf" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])]

rule unionize_kmers:
	input:
		get_list_kmers_input
	output:
		temp("{assembly}_kmerList.txt")
	log:
		"logs/unionize_kmers/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda: 
		"../envs/kmc.yml"
	shell:
		"""
		# 1. concatenate kmer count files
		# 2. remove kmers that occur less than countThresh times because they're due to sequencing errors
		# 3. extract just kmers
		# 4. remove duplicate kmers
		# 5. get a random subset of kmers for downstream analyses
		# 6. sort random k-mer subset so that merging is easier
		# cat {input} | awk '(($2 >= {params.countThresh}))' | cut -f1 1> {output} 2> {log}
		DBFILES=$(echo {input} | sed 's/.kmc_pre//g' | sed 's/.kmc_suf//g')
		INDEX=1

		echo "List of database files that will be merged:"
		echo $DBFILE
		for FILE in DBFILES
		do
			if [[ $INDEX -eq 1 ]]; then
				# in first round of loop, unionize first two files
				echo "Merging first two files..."
				FILE2=("${DBFILES[@]:1:1}")
				
				echo $FILE
				echo $FILE2

				kmc_tools simple $FILE $FILE2 union grandsum &>> {log}
			elif [[ $INDEX -eq 2 ]]; then
				# in second round of loop, just skip to third round because second file already unionized
				continue
			else
				echo "Merging $FILE into grand total..."
 
				# in round 3 and beyond, just add each subsequent file to union
				kmc_tools simple grandsum $FILE union tmp_union &>> {log}

				# rename temporary output to growing output
				mv tmp_union.kmc_pre grandsum.kmc_pre 
				mv tmp_union.kmc_suf grandsum.kmc_suf
			fi
			echo Increment index...
			((INDEX++))
			echo $INDEX
		done

		# after all files are merged, dump result to text file
		echo Dumping kmers to text file...
                kmc_tools transform grandsum dump {output} &>> {log}
		"""
