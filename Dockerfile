FROM busybox as builder
WORKDIR /src
ENV CRYPTO_VERSION=0.21.2
RUN wget https://bitcoincore.org/bin/bitcoin-core-${CRYPTO_VERSION}/bitcoin-${CRYPTO_VERSION}-x86_64-linux-gnu.tar.gz && tar -xf bitcoin-${CRYPTO_VERSION}-x86_64-linux-gnu.tar.gz && mv bitcoin-${CRYPTO_VERSION}/bin/bitcoind /src/bitcoind

FROM debian:bullseye-slim
COPY --from=builder /src/bitcoind /usr/local/bin/bitcoind
COPY bitcoin.conf /etc/bitcoin/bitcoin.conf
CMD ["/usr/local/bin/bitcoind", "-conf=/etc/bitcoin/bitcoin.conf", "-daemon=0"]
