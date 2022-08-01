#!/usr/bin/env bash

KUSTOMIZE_VERSION=v4.5.5
KUBECTL_VERSION=v1.23.5
KREW_VERSION=v0.4.3
KOMPOSE_VERSION=v1.26.1
YQ_VERSION=v4.25.1
HELM_VERSION=v3.9.0
INSTALL_DIR=${INSTALL_DIR:=./bin}
ARCH=${ARCH:=amd64}
TMP_DIR="./tmp"

function install_brew_tools() {
    brew tap fairwindsops/tap
    brew install \
        kubectl kustomize krew helm yq jq fairwindsops/tap/nova
}

function install_krew_tools() {
    kubectl krew install ns ctx
}

function install_crossplane_cli() {
    curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
}

function install_kubectl_binary() {
    local path="${INSTALL_DIR}/kubectl"
    local url="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl"
    curl -L "${url}" -o "${path}"
    chmod +x "${path}"
}

function install_krew_binary() {
    local tmp="${TMP_DIR}"
    local krew="krew-linux_${ARCH}"
    local krew_release="${krew}.tar.gz"
    local pkg="${tmp}/${krew_release}"
    local file="${tmp}/${krew}"
    local url="https://github.com/kubernetes-sigs/krew/releases/latest/download/${krew_release}"
    curl -L "${url}" -o "${pkg}"
    tar -xvzf "${pkg}" -C "${tmp}"
    chmod +x "${file}"
    mv "${file}" ${INSTALL_DIR}/kubectl-krew
}

function install_kustomize_binary() {
    local tmp="${TMP_DIR}"
    local pkg="${tmp}/kustomize.tar.gz"
    local release="kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz"
    local url="https://github.com/kubernetes-sigs/kustomize/releases/download/${release}"
    curl -L "${url}" -o "${pkg}"
    tar -xvzf "${pkg}" -C ${INSTALL_DIR}
    chmod +x ${INSTALL_DIR}/kustomize
}

function install_helm_binary() {
    local tmp="${TMP_DIR}"
    local release="helm-${HELM_VERSION}-linux-${ARCH}.tar.gz"
    local url="https://get.helm.sh/${release}"
    local pkg="${tmp}/${release}"
    curl -L "${url}" -o "${pkg}"
    tar -xvzf "${pkg}" -C "${tmp}"
    mv "${tmp}/linux-${ARCH}/helm" ${INSTALL_DIR}/helm
    chmod +x ${INSTALL_DIR}/helm
}

function install_kompose_binary() {
    local url="https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-${ARCH}"
    curl -L $url -o ${INSTALL_DIR}/kompose
    chmod +x ${INSTALL_DIR}/kompose
}

function install_yq_binary() {
    local url="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${ARCH}"
    local file="${INSTALL_DIR}/yq"
    curl -L "${url}" -o "${file}"
    chmod +x "${file}"
}

function install_kubectl_plugins() {
    local dir="./kubectl/*"
    for f in ${dir}
    do 
        local fname=$(basename $f)
        cp $f "${INSTALL_DIR}/kubectl-${fname%.*}"
    done
}

function install_kustomize_plugins() {
    local kdir="${XDG_CONFIG_HOME}/kustomize"
    mkdir -p "${kdir}" "${kdir}/plugin" "${kdir}/plugin/kubed.io"
    cp -r ./kustomize/ "${kdir}/plugin/kubed.io/"
}

function install() {
    mkdir -p $INSTALL_DIR $TMP_DIR
    install_kustomize_binary
    install_kubectl_binary
    install_krew_binary
    install_kompose_binary
    install_helm_binary
    install_yq_binary
    install_kubectl_plugins
}

"${@}"