FROM golang:1.11-alpine as builder
WORKDIR /go/src/gooscmd/src
COPY . /go/src/gooscmd/.
RUN go build -o ../gooscmd

FROM alpine:3.8

ENTRYPOINT ["/usr/bin/gooscmd"]
COPY --from=builder /go/src/gooscmd/gooscmd /usr/bin/gooscmd
