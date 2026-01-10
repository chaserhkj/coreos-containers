[[ $TORCH_BACKEND == cu* ]] || exit 0
set -e
wget -O /tmp/keyring.deb https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i /tmp/keyring.deb
rm -f /tmp/keyring.deb
apt-get update
apt-get install -y cuda-toolkit
