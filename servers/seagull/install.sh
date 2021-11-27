# Ubuntu21.10のRaspberry Pi 4のKernelにはVXLANのモジュールが含まれていない
# そのためデフォルトのUbuntu21.10 for rasp上ではCalico含むCNIが起動できなくなる
# そこで不足したモジュールをlinux-modules-extra-raspiでインストールする必要がある
# apt update && apt install linux-modules-extra-raspi -y && reboot

# prepare install containerd and kubernetes
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

cat <<EOF  > /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF > /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF > /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

apt update && apt upgrade -y
apt install apt-transport-https ca-certificates curl gnupg lsb-release nfs-common iptables arptables ebtables -y
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
swapoff -a
sysctl --system

# install containerd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install containerd.io
mkdir -p /etc/containerd
containerd config default | sed -e '/containerd.runtimes.runc.options/a \ \ \ \ \ \ \ \ \ \ \  SystemdCgroup = true' | tee /etc/containerd/config.toml
systemctl restart containerd

# install kubeadm
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl containerd.io

# All done
echo "All Done!!!! Congratulations!!!"
