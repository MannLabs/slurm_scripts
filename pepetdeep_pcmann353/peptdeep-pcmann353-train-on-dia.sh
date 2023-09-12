#!/bin/bash -l
#SBATCH -J peptdeep
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --chdir=./

POOL_MANN_PROJECTS=/mnt/pool-mann-projects
POOL_MANN_PUB=/mnt/pool-mann-pub

################################
### instrument=QE for astral ###
################################
instrument=QE

peptdeep cmd-flow \
--task_workflow train \
--model_mgr--transfer--model_output_folder ./refined-models/ \
--peak_matching--ms2_ppm True \
--peak_matching--ms2_tol_value 10.0 \
--thread_num 16 \
--model_mgr--default_nce 25.0 \
--model_mgr--default_instrument ${instrument} \
--model_mgr--external_ms2_model ${POOL_MANN_PROJECTS}"/xxx/ms2.pth" \
--model_mgr--external_rt_model ${POOL_MANN_PROJECTS}"/xxx/rt.pth" \
--model_mgr--external_ccs_model ${POOL_MANN_PROJECTS}"/xxx/ccs.pth" \
--model_mgr--transfer--psm_modification_mapping "Dimethyl@Any_N-term:_(Dimethyl-n-0);_(Dimethyl);(UniMod:36)" "Dimethyl@K:K(Dimethyl-K-0);K(Dimethyl);K(UniMod:36)" \
--model_mgr--transfer--epoch_ms2 60 \
--model_mgr--transfer--warmup_epoch_ms2 20 \
--model_mgr--transfer--epoch_rt_ccs 100 \
--model_mgr--transfer--warmup_epoch_rt_ccs 20 \
--model_mgr--transfer--psm_type diann \
--model_mgr--transfer--psm_files xxx/report.tsv \
--model_mgr--transfer--ms_file_type thermo_raw \
--model_mgr--transfer--ms_files xxx/xxx.raw xxx/yyy.raw \
--model_mgr--transfer--psm_num_to_train_ms2 10000 \
--model_mgr--transfer--psm_num_to_test_ms2 10000 \
--model_mgr--transfer--psm_num_to_train_rt_ccs 10000 \
--model_mgr--transfer--psm_num_to_test_rt_ccs 10000 \


