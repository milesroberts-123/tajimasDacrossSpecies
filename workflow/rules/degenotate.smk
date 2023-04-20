rule degenotate:
	input:
		genome="data/assemblies/{assembly}.fa",
		annot="data/annotations/{assembly}.gff3"
	output:
		"data/{assembly}_fourfoldDegenerateSites.bed"
	params:
		outputFolder="data/degenotateOutput/{assembly}"
	threads: 1
	resources:
		mem_mb_per_cpu=64000
	conda:
		"../envs/degenotate.yml"
	shell:
		""" 
		# before running degenotate, check that correct python version is installed
		# ml -*
		echo $CONDA_PREFIX
		which python
		python --version

		# run degenotate
		$CONDA_PREFIX/bin/python $CONDA_PREFIX/bin/degenotate.py --overwrite -d " " -a {input.annot} -g {input.genome} -o {params.outputFolder}

		# subset out four-fold degenerate sites
		awk '(($5 == 4))' {params.outputFolder}/degeneracy-all-sites.bed > {output}
		"""
