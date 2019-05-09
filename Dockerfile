#Build stage
FROM golang:1.12.4 AS builder

#Set the current working directory inside the container
WORKDIR $GOPATH/src/test

#Copy complete directory over
COPY . .

#Download dependencies
RUN go get -u github.com/jstemmer/go-junit-report
RUN go get -d -v ./...

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $GOPATH/bin/test .

#Second stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /go/bin/test .
#COPY --from=builder /go/src/ms-lender-loan/config.yaml .

EXPOSE 9000

CMD [ "./test" ]