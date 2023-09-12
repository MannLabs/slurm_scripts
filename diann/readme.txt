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