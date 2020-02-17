# alignment and variant calling on new heteroclitus WGS data

- ref genome is Reid et al. 2017. symlinked to `/genome` directory

three sources of data:

1. new data from collaborators Matson and Mayden
	- data symlinked to `/data` directory
2. Reid et al. 2016 data
    - three low cov populations are already aligned. bam files symlinked to `/results/alignments`directory in project
    - two 6x coverage populations need to have fastqs concatenated, aligned. scripts to do this will read and write OUTSIDE the project directory. resulting bam files will be symlinked to `/results/alignments` directory
3. Oziolor et al. 2019
	- all samples already aligned. symlinked to `/results/alignments` directory


new data has notable adapter contamination. 

	- comparing variant calls on 7 samples with/out trimming. 