rule degenotate:
	input:
		genome="data/assemblies/{assembly}.fa",
		annot="data/annotations/{assembly}.gff3"
	output:
		"data/{assembly}_fourfoldDegenerateSites.bed"
	params:
		condaStatus=get_conda_status,
		outputFolder="data/degenotateOutput/{assembly}"
	threads: 1
	resources:
		mem_mb_per_cpu=32000
	conda:
		"../envs/degenotate.yml"
	shell:
		"""
		# remove lengthy titles so fasta headers match gff exactly
		# replace ambiguous bases with N
		#scripts/seqkit replace -s -p [^ATGC] -r N {input.genome} | scripts/seqkit replace -p " .*" -r "" > data/genome_shortTitles_noAmbig.fa
 
		# before running degenotate, check that correct python version is installed
		# ml -*
		echo $CONDA_PREFIX
		which python
		python --version

		# run degenotate, remove any extra information in fasta header after initial key
		# if previous run failed, overwrite that failed run
		# if conda is enabled, use fastp conda env
                # if conda is disabled, check scripts for fastp binary
                if [ "{params.condaStatus}" == "True" ]; then
			$CONDA_PREFIX/bin/python $CONDA_PREFIX/bin/degenotate.py --overwrite -d " " -a {input.annot} -g {input.genome} -o {params.outputFolder}
		else
			scripts/degenotate/degenotate.py --overwrite -d " " -a {input.annot} -g {input.genome} -o {params.outputFolder}
		fi

		# subset out four-fold degenerate sites
		awk '(($5 == 4))' {params.outputFolder}/degeneracy-all-sites.bed > {output}
		"""
