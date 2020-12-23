#!/bin/bash

jid1=$(sbatch --parsable 01_bcftools_array.sh 0)
jid2=$(sbatch --parsable --dependency=afterok:$jid1 01_bcftools_array.sh 1000)
jid3=$(sbatch --parsable --dependency=afterok:$jid2 01_bcftools_array.sh 2000)
jid4=$(sbatch --parsable --dependency=afterok:$jid3 01_bcftools_array.sh 3000)
jid5=$(sbatch --parsable --dependency=afterok:$jid4 01_bcftools_array.sh 4000)
jid6=$(sbatch --parsable --dependency=afterok:$jid5 01_bcftools_array.sh 5000)
jid7=$(sbatch --parsable --dependency=afterok:$jid6 01_bcftools_array.sh 6000)
jid8=$(sbatch --parsable --dependency=afterok:$jid7 01_bcftools_array.sh 7000)
jid9=$(sbatch --parsable --dependency=afterok:$jid8 01_bcftools_array.sh 8000)
jid10=$(sbatch --parsable --dependency=afterok:$jid9 01_bcftools_array.sh 9000)
jid11=$(sbatch --array=[1-180]%30 --parsable --dependency=afterok:$jid10 01_bcftools_array.sh 10000)
