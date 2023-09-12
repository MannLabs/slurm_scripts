# ssh -l username -X hpcl8001

module purge
module load cuda/11.4
module load anaconda/3/2019.03

conda create -n peptdeep python=3.9 -y
conda activate peptdeep

pip install -e /fs/pool/pool-mann-projects/Feng/pcmann353_server/mpi_slurm/src/alphabase
pip install -e /fs/pool/pool-mann-projects/Feng/pcmann353_server/mpi_slurm/src/alpharaw
pip install -e /fs/pool/pool-mann-projects/Feng/pcmann353_server/mpi_slurm/src/peptdeep
pip install -e /fs/pool/pool-mann-projects/Feng/pcmann353_server/mpi_slurm/src/peptdeep-hla

