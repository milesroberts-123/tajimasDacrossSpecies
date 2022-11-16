rule split_kmer_list:
	input:
		"kmerList.txt"
	output:
		expand("kmerList_{index}", index=list(range(9)))
	params:
		prefix="kmerList_",
		numChunks=10
	resources:
		mem_mb_per_cpu=4000
	shell:
		"split --numeric-suffixes --number=l/{params.numChunks} {input} {params.prefix}"
