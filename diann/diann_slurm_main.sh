#!/bin/bash -l
# SEARCH_TYPE can be "merge-lib", "first-search", "second-search"

_wait="--wait"


#***********************************************************
#************** NO SPACES in the file paths ****************
#***********************************************************
############## how to use this script #####################
### 1. login hpcl: ssh -l your_user_name -X hpcl7001
### 
### 2. copy the script folder to your_pool_folder on windows or use: copy -r /fs/pool/pool-mann-pub/User/Feng/diann_linux/slurm_scripts/diann/* your_pool_folder
### 
### 3. cd your_pool_folder
### 
### 4. sh diann_slurm_main.sh to run jobs

### [5] check job ids in the queue: "squeue" or "squeue -u {username}"
### [6] cancel a job: scancel your_job_id


### Please use your email address
mail_user='wzeng@biochem.mpg.de'

### Change settings below for your project
# *.d for bruker, .mzml for thermo. Or .dia for any diann converted raw files
# For thermo raw, you have to convert .raw files into .dia on windows using DIANN or .mzml files using msconvert
RAW_FILES='/fs/pool/pool-mann-projects/Feng/HLA-DB/public_raw/PXD034772/DIA/raw/20200904_DIA_COL011-0000[1-5]a-HLAIp_'*.dia
### all diann output files will be saved into this $OUT_DIR
OUT_DIR="/fs/pool/pool-mann-projects/Feng/HLA-DB/public_raw/PXD034772/DIA/COL011-00001a-00005a/person-lib-hla-db-fdr001/diann_out"

### spectral library
SPECLIB="/fs/pool/pool-mann-projects/Feng/HLA-DB/public_raw/PXD034772/DIA/COL011-00001a-00005a/person-lib-hla-db-fdr001/HLA_ch=1-4_mz=350-1250_mod=1_QE27.5.tsv.speclib"
### fasta files, can be non-existing file (X.fasta)
FASTAS="/fs/pool/pool-mann-projects/Feng/fasta/X.fasta"

MASS_ACC=""
MASS_ACC_MS1=""
SCAN_WINDOW=""
is_mDIA=no

############### Additional DiaNN commands ################
other_params="" # for example, variable modifications

##########################################################

#################### DiaNN folder ########################
DIANN="/fs/pool/pool-mann-pub/User/Feng/diann_linux/1.8.1/diann"

###### for tsv lib, convert it into .speclib format ######
if [[ ${SPECLIB} == *.tsv ]] ; then
	${DIANN} --lib "${SPECLIB}" --out "${SPECLIB}".report.tsv --f x.raw
	SPECLIB="${SPECLIB}".speclib
	rm x.raw.quant
	rm "${SPECLIB}".report.*
fi
raw_files=(${RAW_FILES})
array=0-$((${#raw_files[@]}-1))%24
echo 'sbatch array='"${array}"


mkdir -p "${OUT_DIR}"
mkdir -p ./logs

### first-search
echo "first-search"
gen_lib=no
cpus_per_task=10
sbatch --export=ALL,SEARCH_TYPE="first-search",DIANN="${DIANN}",RAW_FILES="${RAW_FILES}",OUT_DIR="${OUT_DIR}",SPECLIB="${SPECLIB}",FASTAS="${FASTAS}",MASS_ACC=${MASS_ACC},MASS_ACC_MS1=${MASS_ACC_MS1},SCAN_WINDOW=${SCAN_WINDOW},is_mDIA=${is_mDIA},other_params="${other_params}",gen_lib=${gen_lib},cpus=${cpus_per_task} --array="${array}" --cpus-per-task=${cpus_per_task} --mem=110GB --mail-user=${mail_user} ${_wait} sbatch_run_diann.sh

### second-search
echo "second-search"
gen_lib=yes
cpus_per_task=40
sbatch --export=ALL,SEARCH_TYPE="second-search",DIANN="${DIANN}",RAW_FILES="${RAW_FILES}",OUT_DIR="${OUT_DIR}",SPECLIB="${SPECLIB}",FASTAS="${FASTAS}",MASS_ACC=${MASS_ACC},MASS_ACC_MS1=${MASS_ACC_MS1},SCAN_WINDOW=${SCAN_WINDOW},is_mDIA=${is_mDIA},other_params="${other_params}",gen_lib=${gen_lib},cpus=${cpus_per_task} --cpus-per-task=${cpus_per_task} --mem=440GB --mail-user=${mail_user} sbatch_run_diann.sh

