# Dockerfile  
FROM golang:1.19 AS builder  

WORKDIR /app  

COPY server_main.go .  

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server server.go
 

# Create the final container  
FROM alpine:latest  

WORKDIR /root/  

COPY --from=builder /app/server .  

CMD ["./server"]
