rule build_coding_kmer_database.smk
	input:
	shell:
	"kmc -k{params.kmerLength} -m16 -t{threads} -ci1 -cs1 {input.read1} temporary1_{wildcards.samplePe} tmp_{wildcards.samplePe}"
