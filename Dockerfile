# Stage 1: Build the application using the corresponding Go version
FROM golang:1.21-alpine AS builder

# Install git to fetch dependencies if needed and other build tools
RUN apk --no-cache add git

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the go mod and sum files and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy

# Copy the entire project into the working directory
COPY . .

# Build the Go application
RUN go build -o nft_scraper

# Stage 2: Create the final image
FROM alpine:3.18

ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_DB
ARG POSTGRES_HOST
ARG POSTGRES_PORT

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}
ENV POSTGRES_HOST=${POSTGRES_HOST}
ENV POSTGRES_PORT=${POSTGRES_PORT}

# Use a non-root user for enhanced security
RUN addgroup -S g-blockparty && adduser -S blockparty -G g-blockparty

# Set working directory in the final image
WORKDIR /app

# Copy the executable from the builder stage
COPY --from=builder /app/nft_scraper .

# Copy any necessary files like the .env and the CSV data directory
COPY --from=builder /app/data ./data

# Set permissions for non-root user
RUN chown -R blockparty:g-blockparty /app && chmod +x /app/nft_scraper

# Switch to non-root user
USER blockparty

# Command to run the executable
CMD ["./nft_scraper"]
