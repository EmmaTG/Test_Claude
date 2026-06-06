# --- Stage 1: Build the binary ---
FROM golang:1.26-alpine AS builder

# Install git and certificates (useful for fetching dependencies)
RUN apk add --no-cache git ca-certificates

WORKDIR /app

# Copy dependency files first to leverage Docker caching
COPY go.mod go.sum* ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o microservice ./src

# --- Stage 2: Final lightweight runtime ---
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/microservice .

# Expose the port your Go app listens on
EXPOSE 8080

# Run the application
CMD ["./microservice"]