FROM registry.access.redhat.com/ubi8/ubi-minimal AS builder
WORKDIR /build
RUN microdnf install -y gcc make autoconf automake libtool git
RUN git clone https://github.com/pabeni/iperf.git
WORKDIR /build/iperf
RUN ./configure
RUN make install

FROM registry.access.redhat.com/ubi8/ubi-minimal
WORKDIR /
COPY --from=builder /usr/local/bin/iperf3 /usr/bin
COPY --from=builder /usr/local/lib/libiperf.so.0.0.0 /usr/lib64
RUN ln -s libiperf.so.0.0.0 /usr/lib64/libiperf.so.0
EXPOSE 5201
ENTRYPOINT trap : TERM INT; sleep infinity & wait # Listen for kill signals and exit quickly.
