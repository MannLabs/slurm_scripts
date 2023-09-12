

sudo systemctl start slurmctld
sudo systemctl start slurmd

mkdir -p /mnt/pool-mann-projects
mkdir -p /mnt/pool-mann-pub

sudo mount -t cifs -o user=wzeng,uid=1001,gid=1001,file_mode=0777,dir_mode=0777 //samba-pool-mann-projects.biochem.mpg.de/pool-mann-projects /mnt/pool-mann-projects



sudo mount -t cifs -o user=wzeng,uid=1001,gid=1001,file_mode=0777,dir_mode=0777 //samba-pool-mann-pub.biochem.mpg.de/pool-mann-pub /mnt/pool-mann-pub

