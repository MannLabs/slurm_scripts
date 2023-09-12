#!/bin/bash -l
#SBATCH -J peptdeep
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --chdir=./
#SBATCH --mem=128G
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:1
#SBATCH --mail-type=all
#SBATCH --mail-user=wzeng@biochem.mpg.de
#SBATCH --time=14-00:00:00


module purge
module load cuda/11.4
module load anaconda/3/2019.03

conda activate peptdeep

POOL_MANN_PROJECTS=/fs/pool/pool-mann-projects
POOL_MANN_PUB=/fs/pool/pool-mann-pub

speclib_folder=./QE25_speclib

predict_peptide_tsv=${POOL_MANN_PROJECTS}/path/to/prediction_save_as_in_tsv

DIANN="/mnt/pool-mann-pub/User/Feng/diann_linux/1.8.1/diann"

peptdeep_hla class1 \
--fasta ${POOL_MANN_PROJECTS}/Feng/speclib_for_people/fasta/UP000005640_human_reviewed.fasta \
--prediction_save_as ${predict_peptide_tsv} \
--pretrained_model ${POOL_MANN_PROJECTS}/path/to/model \
--peptide_file_to_train ${POOL_MANN_PROJECTS}/path/to/peptide_file_to_train \
--training_file_type diann \
--training_raw_names rawname1 rawname2 \
--model_save_as ${POOL_MANN_PROJECTS}/path/to/peptide_file_to_train \
--min_peptide_length 8 \
--max_peptide_length 14 \

################################
### instrument=QE for astral ###
################################
instrument=QE

peptdeep cmd-flow \
--task_workflow library \
--settings_yaml ${POOL_MANN_PROJECTS}/peptdeep.yaml \
--library--output_folder ${speclib_folder} \
--thread_num 16 \
--model_mgr--default_nce 25.0 \
--model_mgr--default_instrument ${instrument} \
--model_mgr--external_ms2_model "xxx/ms2.pth" \
--model_mgr--external_rt_model "xxx/rt.pth" \
--model_mgr--external_ccs_model "xxx/ccs.pth" \
--library--infile_type sequence_table \
--library--infiles ${predict_peptide_tsv} \
--library--min_var_mod_num 0 \
--library--max_var_mod_num 1 \
--library--min_precursor_charge 1 \
--library--max_precursor_charge 4 \
--library--min_precursor_mz 370.0 \
--library--max_precursor_mz 1000.0 \
--library--var_mods "Oxidation@M" "Carbamidomethyl@C" \
--library--fix_mods \
--library--decoy None \
--library--output_tsv--enabled True \
--library--rt_to_irt True \
# --library--labeling_channels "0:Dimethyl@Any_N-term;Dimethyl@K" \


echo "Converting tsv speclib to diann speclib ..."
${DIANN} --lib ${speclib_folder}/predict.speclib.tsv --out ${speclib_folder}/report.tsv --f x.raw
rm x.raw.quant
rm ${speclib_folder}/report.*

