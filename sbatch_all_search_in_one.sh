#!/bin/bash -l
#SBATCH -J diann
#SBATCH --ntasks=1
#SBATCH --nodes=1
####SBATCH --cpus-per-task=10 # 40 CPUs per node; each CPU allows one thread. So set DiaNN's "--threads" equal to this number
####SBATCH --mem=110GB        # 512GB per node
#SBATCH --mail-type=all
#SBATCH --mail-user=wzeng@biochem.mpg.de  # change to your email address
#SBATCH --time=14-00:00:00    # slurm server only allows maximal running time of 14 days
#SBATCH --chdir=./logs


echo "diann search type is ${SEARCH_TYPE}"
RAW_FILES=(${RAW_FILES})
FASTAS=(${FASTAS})


################ DO NOT CHANGE CMDs below if possible ################
if [[ "${SEARCH_TYPE}" == "merge-lib" ]]; then
    OUTFILE=${OUT_DIR}/xx_gen_lib_rpt.tsv
    FILE=${OUT_DIR}/xxx.d # any non-existing file, diann will skip the search
    OUTLIB=${OUT_DIR}/xx_gen_lib.tsv
elif [[ "${SEARCH_TYPE}" == "first-search" ]]; then
    FILE=${RAW_FILES[$SLURM_ARRAY_TASK_ID]}
    OUTLIB=${OUT_DIR}/$(basename -- "${FILE}").lib.tsv
    OUTFILE=${OUT_DIR}/$(basename -- "${FILE}").tsv
else
    OUTFILE=${OUT_DIR}/report.tsv
    OUTLIB=${OUT_DIR}/report_lib.tsv
fi
echo ${FILE}
echo ${OUTFILE}
echo ""

DIANN="/fs/pool/pool-mann-pub/User/Feng/diann_linux/1.8.1/diann"

#################### common params ########################
diann_params='--threads '${cpus}' --verbose 1 --qvalue 0.01 --matrices --relaxed-prot-inf --peak-center --no-ifs-removal --rt-profiling --peak-center --no-ifs-removal --smart-profiling --out "'${OUTFILE}'" --temp "'${OUT_DIR}'" --out-lib "'${OUTLIB}'"'
if [[ "${gen_lib}" == "yes" ]]; then
    diann_params=${diann_params}' --gen-spec-lib'
fi
if [[ ! -z "${MASS_ACC}" ]]; then
    diann_params=${diann_params}' --mass-acc '${MASS_ACC}
fi
if [[ ! -z "${MASS_ACC_MS1}" ]]; then
    diann_params=${diann_params}' --mass-acc-ms1 '${MASS_ACC_MS1}
fi
if [[ ! -z "${SCAN_WINDOW}" ]]; then
    diann_params=${diann_params}' --window '${SCAN_WINDOW}
fi
###########################################################

############ use .quant file for second search ############
if [[ "${SEARCH_TYPE}" == "second-search" ]]; then
    diann_params=${diann_params}' --use-quant --reanalyse'
fi
###########################################################

################## mDIA params ############################
if [[ "$is_mDIA" == "yes" ]]; then
    diann_params=${diann_params}' --fixed-mod Dimethyl,28.0313,nK --channels "Dimethyl,0,nK,0:0;" "Dimethyl,4,nK,4.0251:4.0251;" "Dimethyl,8,nK,8.0444:8.0444" --original-mods --peak-translation --ms1-isotope-quant -–mass-acc-quant 10.0'
fi
###########################################################

################## speclib params #########################
diann_params=${diann_params}' --lib "'${SPECLIB}'"'
###########################################################

#################### fasta params #########################
fasta_params=""
for fasta in "${FASTAS[@]}"; do
    if [[ -d ${fasta} ]]; then
        fasta_params=${fasta_params}' --fasta "'${fasta}'"'
    fi
    if [[ ! -z "${fasta_params}" ]]; then
        diann_params=${diann_params}' -reannotate'${fasta_params}
    fi
done
###########################################################

################## RAW files ##############################
if [[ "${SEARCH_TYPE}" == "second-search" ]]; then
    for FILE in "${RAW_FILES[@]}"; do
        diann_params=${diann_params}' --f "'${FILE}'"'
    done
else
    diann_params=${diann_params}' --f "'${FILE}'"'
fi
###########################################################

echo "${DIANN} ${diann_params}"
echo "=================================================="

srun ${DIANN} ${diann_params}

