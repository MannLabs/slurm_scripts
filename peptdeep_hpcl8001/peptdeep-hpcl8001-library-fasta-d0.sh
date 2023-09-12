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
# conda create -n peptdeep python=3.9

conda activate peptdeep

POOL_MANN_PROJECTS=/fs/pool/pool-mann-projects
POOL_MANN_PUB=/fs/pool/pool-mann-pub

DIANN=${POOL_MANN_PUB}"/User/Feng/diann_linux/1.8.1/diann"

speclib_folder=./pred_speclib

################################
### instrument=QE for astral ###
################################
instrument=QE

peptdeep cmd-flow \
--task_workflow library \
--library--output_folder ${speclib_folder} \
--thread_num 16 \
--model_mgr--default_nce 25.0 \
--model_mgr--default_instrument ${instrument} \
--model_mgr--external_ms2_model ${POOL_MANN_PROJECTS}"/xxx/ms2.pth" \
--model_mgr--external_rt_model ${POOL_MANN_PROJECTS}"/xxx/rt.pth" \
--model_mgr--external_ccs_model ${POOL_MANN_PROJECTS}"/xxx/ccs.pth" \
--library--infile_type fasta \
--library--infiles ${POOL_MANN_PROJECTS}/Feng/speclib_for_people/fasta/UP000005640_human_reviewed.fasta \
--library--min_var_mod_num 0 \
--library--max_var_mod_num 1 \
--library--min_precursor_charge 1 \
--library--max_precursor_charge 4 \
--library--min_peptide_len 7 \
--library--max_peptide_len 30 \
--library--min_precursor_mz 370.0 \
--library--max_precursor_mz 1000.0 \
--library--var_mods "Oxidation@M" "Acetyl@Protein_N-term" \
--library--fix_mods "Carbamidomethyl@C" \
--library--fasta--protease trypsin \
--library--fasta--max_miss_cleave 1 \
--library--decoy None \
--library--output_tsv--enabled True \
--library--rt_to_irt True \
--library--labeling_channels "0:Dimethyl@Any_N-term;Dimethyl@K" \

echo "Converting tsv speclib to diann speclib ..."
${DIANN} --lib ${speclib_folder}/predict.speclib.tsv --out ${speclib_folder}/report.tsv --f x.raw
rm x.raw.quant
rm ${speclib_folder}/report.*

