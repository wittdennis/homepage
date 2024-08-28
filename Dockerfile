FROM rust:1.80.1-bullseye AS builder

# renovate: datasource=github-releases depName=cargo-binstall packageName=cargo-bins/cargo-binstall versioning=semver-coerced
ARG CARGO_BINSTALL_VERSION=v1.10.3
RUN ARCH=x86_64 && \
    if [ "$(uname -m)" = "aarch64" ]; then ARCH=aarch64; fi && \
    wget https://github.com/cargo-bins/cargo-binstall/releases/download/${CARGO_BINSTALL_VERSION}/cargo-binstall-${ARCH}-unknown-linux-gnu.tgz && \
    tar -xvf cargo-binstall-${ARCH}-unknown-linux-gnu.tgz && \
    cp cargo-binstall /usr/local/cargo/bin && \
    cargo binstall cargo-leptos -y && \
    rustup target add wasm32-unknown-unknown && \
    mkdir -p /app

WORKDIR /app
COPY . .

RUN cargo leptos build --release -vv

FROM debian:bookworm-slim AS runtime
WORKDIR /app
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends openssl ca-certificates \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/homepage /app/.
COPY --from=builder /app/target/site /app/site
COPY --from=builder /app/Cargo.toml /app/

ENV RUST_LOG="info"
ENV LEPTOS_SITE_ADDR="0.0.0.0:8080"
ENV LEPTOS_SITE_ROOT="site"
EXPOSE 8080

CMD ["/app/homepage"]
