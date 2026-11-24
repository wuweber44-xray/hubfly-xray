FROM ghcr.io/xtls/xray-core:latest AS xray
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY --from=xray /usr/local/share/xray/ /usr/local/share/xray/
COPY config.json.template /usr/local/etc/xray/config.json.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /usr/local/bin/xray
ENTRYPOINT ["/entrypoint.sh"]
