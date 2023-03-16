def get_list_kmers_input_pre(wildcards):
	return ["nocds_" + x + "_pe.kmc_pre" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])] + ["nocds_" + x + "_se.kmc_pre" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])]

def get_list_kmers_input_suf(wildcards):
	return ["nocds_" + x + "_pe.kmc_suf" for x in set(samplesPe.loc[samplesPe["genome"] == wildcards.assembly, "replicate"])] + ["nocds_" + x + "_se.kmc_suf" for x in set(samplesSe.loc[samplesSe["genome"] == wildcards.assembly, "replicate"])]

rule unionize_kmers:
	input:
		pre=get_list_kmers_input_pre,
		suf=get_list_kmers_input_suf
	output:
		temp("{assembly}_kmerList.txt")
	log:
		"logs/unionize_kmers/{assembly}.log"
	threads: 1
	resources:
		mem_mb_per_cpu=16000
	conda: 
		"../envs/kmc.yml"
	params:
		kmerCountThreshold=5
	shell:
		"""
		DBFILES=($(echo {input.pre} | sed 's/.kmc_pre//g'))
		INDEX=1

		echo "List of database files that will be merged:" &>> {log}
		echo ${{DBFILES[@]}} &>> {log}
		for FILE in ${{DBFILES[@]}}
		do
			if [[ $INDEX -eq 1 ]]; then
				echo Index is: $INDEX &>> {log}

				# in first round of loop, unionize first two files
				echo "Merging first two files..." &>> {log}
				FILE2=("${{DBFILES[@]:1:1}}")
				
				echo $FILE &>> {log}
				echo $FILE2 &>> {log}

				kmc_tools simple $FILE -ci{params.kmerCountThreshold} $FILE2 -ci{params.kmerCountThreshold}  union grandsum_{wildcards.assembly} &>> {log}
			elif [[ $INDEX -eq 2 ]]; then
				echo Index is: $INDEX &>> {log}
				# in second round of loop, just skip to third round because second file already unionized
				echo Do nothing because second file already merged &>> {log}
			else
				echo Index is: $INDEX &>> {log}
				echo "Merging $FILE into grand total..." &>> {log}
 
				# in round 3 and beyond, just add each subsequent file to union
				kmc_tools simple grandsum_{wildcards.assembly} $FILE -ci{params.kmerCountThreshold} union tmp_union_{wildcards.assembly} &>> {log}

				# rename temporary output to growing output
				mv tmp_union_{wildcards.assembly}.kmc_pre grandsum_{wildcards.assembly}.kmc_pre 
				mv tmp_union_{wildcards.assembly}.kmc_suf grandsum_{wildcards.assembly}.kmc_suf
			fi
			echo Increment index... &>> {log}
			((INDEX++))
			echo Index is now: $INDEX &>> {log}
		done

		# after all files are merged, dump result to text file
		echo Dumping kmers to text file... &>> {log}
                kmc_tools transform grandsum_{wildcards.assembly} dump {output} &>> {log}
		"""
