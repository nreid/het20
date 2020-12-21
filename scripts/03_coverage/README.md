# coverage notes

the aims of these scripts are to identify genotypable regions of the genome by rates of read mapping. final results will be:
1. a targets file that can be used for variant calling, or to exclude alread-called variants from questionable regions. 
2. a count of genotypable sites in 1kb non-overlapping windows. 

output will also be used to search for large-scale duplications/deletions that show big frequency differences between populations. 

results from this directory all written to /results/coverage

scripts in this directory:
- _01_featurecounts_1kb.sh_: runs featurecounts on all samples to count fragments hitting 1kb non-overlapping windows for the whole genome. 
- _02_amh_perbase.sh_: extracts per base coverage for all individuals for amh region. 
- _03_popcov_perbase.sh_: counts the number of individuals with coverage for each site in the genome by population segment (per table in /metadata). 
	- uses _03.1_mpile.sh_ and _03.2_popcount.R_. 
	- copies b-k are because the max array size limit on xanadu is 1000, and this runs per scaffold (10180 scaffolds)