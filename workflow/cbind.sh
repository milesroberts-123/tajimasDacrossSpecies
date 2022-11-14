paste <(cut -f1 kmerRandomSubset.txt) \
<(cut -f2 SRR1946539_se_mergedKmerCounts.txt) <(cut -f2 SRR1946532_se_mergedKmerCounts.txt) <(cut -f2 SRR1946422_pe_mergedKmerCounts.txt) <(cut -f2 SRR1945905_pe_mergedKmerCounts.txt) 
