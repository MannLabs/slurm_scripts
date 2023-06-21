#!/bin/bash -l
# SEARCH_TYPE can be "merge-lib", "first-search", "second-search"


#***********************************************************
#********** file paths MUST NOT contain spaces *************
#***********************************************************
_wait="--wait"


### login hpcl: ssh -l your_user_name -X hpcl7001

### copy the script folder to your workspace pool folder: copy -r /fs/pool/pool-mann-pub/User/diann_linux/slurm_scripts/* your_pool_folder
### cd your_pool_folder

### run jobs: sh run_full_workflow.sh

### check job ids in the queue: "squeue" or "squeue -u {username}"
### cancel a job: scancel your_job_id



### Change settings below for your project
RAW_FILES='/fs/pool/pool-mann-projects/Feng/HLA-DB/public_raw/PXD034772/DIA/raw/20200828_DIA_COL011'*.dia
## all diann output files will be saved into $OUT_DIR
OUT_DIR="/fs/pool/pool-mann-projects/Feng/speclib_for_people/MariaW/HLA_personlibs/9/feng/out_panlib"
SPECLIB="/fs/pool/pool-mann-projects/Feng/speclib_for_people/MariaW/HLA_personlibs/slurm/MSV000084172+PXD004894-fragger.speclib.tsv.speclib"
FASTAS="/fs/pool/pool-mann-projects/Feng/fasta/human.fasta"

MASS_ACC=""
MASS_ACC_MS1=""
SCAN_WINDOW=""
is_mDIA=no
######################################################



raw_files=(${RAW_FILES})
array=0-$((${#raw_files[@]}-1))%24
echo 'sbatch array='"${array}"


mkdir -p "${OUT_DIR}"
mkdir -p ./logs
### first-search
### first-search
echo "first-search"
gen_lib=no
cpus=10
sbatch --export=ALL,SEARCH_TYPE="first-search",RAW_FILES="${RAW_FILES}",OUT_DIR="${OUT_DIR}",SPECLIB="${SPECLIB}",FASTAS="${FASTAS}",MASS_ACC=${MASS_ACC},MASS_ACC_MS1=${MASS_ACC_MS1},SCAN_WINDOW=${SCAN_WINDOW},is_mDIA=${is_mDIA},gen_lib=${gen_lib},cpus=${cpus} --array="${array}" --cpus-per-task=${cpus} --mem=110GB ${_wait} sbatch_all_search_in_one.sh

### second-search
echo "second-search"
gen_lib=yes
cpus=40
sbatch --export=ALL,SEARCH_TYPE="second-search",RAW_FILES="${RAW_FILES}",OUT_DIR="${OUT_DIR}",SPECLIB="${SPECLIB}",FASTAS="${FASTAS}",MASS_ACC=${MASS_ACC},MASS_ACC_MS1=${MASS_ACC_MS1},SCAN_WINDOW=${SCAN_WINDOW},is_mDIA=${is_mDIA},gen_lib=${gen_lib},cpus=${cpus} --cpus-per-task=${cpus} --mem=440GB sbatch_all_search_in_one.sh

