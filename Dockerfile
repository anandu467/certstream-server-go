FROM alpine
WORKDIR /app


# Copy our static executable.
RUN wget -O /app/certstream-server-go https://github.com/d-Rickyy-b/certstream-server-go/releases/download/v1.7.0/certstream-server-go_1.7.0_linux_amd64
COPY ./config.sample.yaml /app/config.yaml

RUN chmod +x /app/certstream-server-go

CMD  caddy run --config /etc/caddy/Caddyfile & /app/certstream-server-go 
