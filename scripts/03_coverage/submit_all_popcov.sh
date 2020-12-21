#!/bin/bash

jid1=$(sbatch --parsable 03_popcov_perbase.sh)
jid2=$(sbatch --parsable --dependency=afterok:$jid1 03b_popcov_perbase.sh)
jid3=$(sbatch --parsable --dependency=afterok:$jid2 03c_popcov_perbase.sh)
jid4=$(sbatch --parsable --dependency=afterok:$jid3 03d_popcov_perbase.sh)
jid5=$(sbatch --parsable --dependency=afterok:$jid4 03e_popcov_perbase.sh)
jid6=$(sbatch --parsable --dependency=afterok:$jid5 03f_popcov_perbase.sh)
jid7=$(sbatch --parsable --dependency=afterok:$jid6 03g_popcov_perbase.sh)
jid8=$(sbatch --parsable --dependency=afterok:$jid7 03h_popcov_perbase.sh)
jid9=$(sbatch --parsable --dependency=afterok:$jid8 03i_popcov_perbase.sh)
jid10=$(sbatch --parsable --dependency=afterok:$jid9 03j_popcov_perbase.sh)
jid11=$(sbatch --parsable --dependency=afterok:$jid10 03k_popcov_perbase.sh)
