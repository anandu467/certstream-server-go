FROM alpine
RUN apk add caddy
WORKDIR /app


# Copy our static executable.
RUN wget -O /app/certstream-server-go https://github.com/d-Rickyy-b/certstream-server-go/releases/download/v1.7.0/certstream-server-go_1.7.0_linux_amd64
COPY ./config.sample.yaml /app/config.yaml

# Caddyfile configuration
RUN echo "localhost:80 {\n\
    reverse_proxy /ws* 127.0.0.1:8080 {\n\
       header_up Host {host}\n\
       header_up X-Real-IP {remote_host}\n\
       header_up X-Forwarded-For {remote_host}\n\
       header_up X-Forwarded-Proto {scheme}\n\
       header_up Origin localhost\n\
    }\n
}" > /etc/caddy/Caddyfile


RUN cat /proc/cpuinfo
RUN chmod +x /app/certstream-server-go

# Create the startup script
RUN echo "#!/bin/bash\n\
/app/certstream-server-go &\n\
caddy run --config /etc/caddy/Caddyfile" > /app/start.sh

# Make the startup script executable
RUN chmod +x /app/start.sh

# Expose ports
EXPOSE 80

# Start the startup script
CMD ["/app/start.sh"]
