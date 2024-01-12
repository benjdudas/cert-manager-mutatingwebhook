#
# Build go project
#
FROM golang:1.15-alpine as go-builder

WORKDIR /home/bdudas/dev-cloud/mutating_webhook/cert-manager-mutatingwebhook

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mutatingwebhook *.go

#
# Runtime container
#
FROM alpine:latest  

RUN mkdir -p /app && \
    addgroup -S app && adduser -S app -G app && \
    chown app:app /app

WORKDIR /app

COPY --from=go-builder /home/bdudas/dev-cloud/mutating_webhook/cert-manager-mutatingwebhook .

USER app

CMD ["./cert-manager-mutatingwebhook"]  
