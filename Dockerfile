ARG ALPINE_VERSION=latest
ARG ARCH=amd64

FROM ubuntu AS builder

WORKDIR /app

COPY . . 

RUN apt update && \
    apt install curl -y && \ 
    chmod +x build.sh && \
    ./build.sh install

FROM alpine:${ALPINE_VERSION} AS runner

ARG WKDIR=/kubed

ENV KUBECONFIG=${WKDIR}/.kube/config \
    XDG_CONFIG_HOME=${WKDIR} \
    ENABLE_ALPHA_PLUGINS="true" \
    PATH="${WKDIR}/.krew/bin:${WKDIR}/bin:$PATH"

RUN apk --no-cache --update add \
        curl \
        gettext \
        bash \
        git \
        ncurses \
        aws-cli \
        py-pip \
    && rm -rf /var/cache/apk/* \
    && addgroup \
        --system \
        --gid 1000 \
        kubed \
    && adduser \
        --system \
        --home ${WKDIR} \
        --shell /bin/bash \
        --uid 1000 \
        --ingroup kubed \
        --no-create-home \
        kubed \
    && mkdir -p \
       ${WKDIR} \
       ${WKDIR}/kustomize \
       ${WKDIR}/kustomize/plugin \
       ${WKDIR}/.kube \
       ${WKDIR}/.krew \
    && chown -R kubed:kubed ${WKDIR}

WORKDIR ${WKDIR}

COPY --from=builder --chown=kubed:kubed /app/bin ${WKDIR}/bin
COPY --from=builder --chown=kubed:kubed /app/kustomize ${WKDIR}/kustomize/plugin/kubed.io

USER kubed

RUN kubectl krew install \
    ctx ns view-secret neat \
    view-secret view-serviceaccount-kubeconfig \
    get-all whoami

SHELL [ "/bin/bash", "-c" ]

ENTRYPOINT [ "kubectl" ]

CMD ["version"]