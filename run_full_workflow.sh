#!/bin/bash -l
# SEARCH_TYPE can be "merge-lib", "first-search", "second-search"

#********** file paths MUST NOT contain spaces *************

### login hpcl: ssh -l your_user_name -X hpcl7001
### copy the script folder to your workspace pool folder: copy -r /fs/pool/pool-mann-pub/User/diann_linux/slurm_template/* your_pool_folder
### cd your_pool_folder
### check job ids in the queue: squeue or squeue -u {user}
### cancel a job: scancel your_job_id

_wait="--wait"



RAW_FILES='/fs/pool/pool-mann-projects/Feng/HLA-DB/public_raw/PXD034772/DIA/raw/20200828_DIA_COL011'*.dia
## all diann output files will be saved into $OUT_DIR
OUT_DIR="/fs/pool/pool-mann-projects/Feng/speclib_for_people/MariaW/HLA_personlibs/9/feng/out_panlib"
SPECLIB="/fs/pool/pool-mann-projects/Feng/speclib_for_people/MariaW/HLA_personlibs/slurm/MSV000084172+PXD004894-fragger.speclib.tsv.speclib"
FASTAS="/fs/pool/pool-mann-projects/Feng/fasta/human.fasta"


raw_files=(${RAW_FILES})
array=0-$((${#raw_files[@]}-1))%20
echo 'sbatch array='"${array}"


mkdir -p "${OUT_DIR}"
mkdir -p ./logs
### first_search
sbatch --export=ALL,SEARCH_TYPE="first-search",RAW_FILES="${RAW_FILES}",OUR_DIR="${OUT_DIR}",SPECLIB="${SPECLIB}",FASTAS="${FASTAS}" --array="${array}" ${_wait} sbatch_all_search_in_one.sh

### second_search
sbatch --export=ALL,SEARCH_TYPE="second-search",RAW_FILES="${RAW_FILES}",OUR_DIR="${OUT_DIR}",SPECLIB="${SPECLIB}",FASTAS="${FASTAS}" sbatch_all_search_in_one.sh

