ARG OS=ubuntu
ARG OS_VER=focal
FROM ${OS}:${OS_VER} as os-base

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -yqq \
    curl unzip jq bash-completion

# install bitcoind
FROM os-base as bitcoind-install

# add work user
ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} ${GROUPNAME} && \
    useradd -m -u ${UID} -g ${GID} ${USERNAME}


# Install Bitcoin Core binaries and libraries
ARG BITCOIND_VER=26.0
RUN cd /tmp && \
	curl -# -sLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIND_VER}/bitcoin-${BITCOIND_VER}-x86_64-linux-gnu.tar.gz && \
	tar -zxf bitcoin-${BITCOIND_VER}-x86_64-linux-gnu.tar.gz && \
	cd bitcoin-${BITCOIND_VER} && \
	install -vD bin/* /usr/bin && \
	install -vD lib/* /usr/lib && \
	cd /tmp && \
	rm bitcoin-${BITCOIND_VER}-x86_64-linux-gnu.tar.gz && \
	rm -rf bitcoin-${BITCOIND_VER}

# Install runtime scripts, bash-completion and configuration files

# bash completion for bitcoind and bitcoin-cli
ENV GH_URL https://raw.githubusercontent.com/bitcoin/bitcoin/master/
ENV BC /usr/share/bash-completion/completions/
ADD $GH_URL/contrib/completions/bash/bitcoin-cli.bash $BC/bitcoin-cli
ADD $GH_URL/contrib/completions/bash/bitcoind.bash $BC/bitcoind
ADD $GH_URL/contrib/completions/bash/bitcoin-tx.bash $BC/bitcoin-tx

# Copy support scripts
COPY bitcoind-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/bitcoind-entrypoint.sh
COPY mine.sh /usr/local/bin
RUN chmod +x /usr/local/bin/mine.sh
COPY cli /usr/local/bin
RUN chmod +x /usr/local/bin/cli

# bitcoind P2P
EXPOSE 18444/tcp
# bitcoind regtest RPC
EXPOSE 18443/tcp
# zmqpubrawblock
EXPOSE 12005/tcp
# zmqpubrawtx
EXPOSE 12006/tcp

USER $USERNAME

# Copy bash configuration directory
COPY --chown=${UID}:${GID} bashrc /home/${USERNAME}/.bashrc

WORKDIR /home/${USERNAME}
ENTRYPOINT ["/usr/local/bin/bitcoind-entrypoint.sh"]

CMD ["/usr/local/bin/mine.sh"]
