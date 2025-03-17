FROM --platform=$BUILDPLATFORM golang:alpine AS builder

COPY --from=tonistiigi/xx / /

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG TARGETPLATFORM
RUN CGO_ENABLED=0 xx-go build -o /WatchYourLAN ./cmd/WatchYourLAN


FROM alpine

WORKDIR /app

RUN apk add --no-cache arp-scan tzdata \
    && mkdir /data

COPY --from=builder /WatchYourLAN /app/

ENTRYPOINT ["./WatchYourLAN"]
