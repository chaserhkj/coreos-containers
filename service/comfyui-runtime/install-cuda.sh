[[ $TORCH_BACKEND == cu* ]] || exit 0
set -e
wget -O /run/keyring.deb https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i /run/keyring.deb
rm -f /run/keyring.deb
apt-get update
apt-get install -y cuda-toolkit
