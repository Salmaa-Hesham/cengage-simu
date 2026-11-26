FROM debian:bookworm-slim
ARG KUBECTL_VERSION
ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/*
RUN test -n "$KUBECTL_VERSION" && test -n "$TARGETARCH" \
    && curl -fsSLo /tmp/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
    && curl -fsSLo /tmp/kubectl.sha256 "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl.sha256" \
    && cd /tmp && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check \
    && install -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl kubectl.sha256
RUN groupadd -g 1000 jenkins && useradd -m -u 1000 -g 1000 jenkins
USER 1000:1000
