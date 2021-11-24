# prevent server from going sleep when it's cover to be closed
cat <<EOF >> /etc/systemd/logind.conf
HandleLidSwitch=ignore
EOF

# prepare install containerd and kubernetes
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
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
apt install apt-transport-https ca-certificates curl gnupg lsb-release nfs-common -y
swapoff -a
sysctl --system

# install containerd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
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

# install NetworkManager
apt install -y network-manager
echo "[[[[[[[[[[  Please upload the netplan configuration to /etc/netplan ]]]]]]]]]]"

# All done
echo "All Done!!!! Congratulations!!!"
