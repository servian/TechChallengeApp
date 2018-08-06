FROM golang:alpine AS build

RUN apk add --no-cache curl git

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

WORKDIR $GOPATH/src/github.com/vibrato/TechTestApp

COPY Gopkg.toml Gopkg.lock $GOPATH/src/github.com/vibrato/TechTestApp/

RUN dep ensure -vendor-only -v

COPY . .

RUN go build -o /TechTestApp

FROM alpine:latest

WORKDIR /TechTestApp

COPY assets ./assets
COPY conf.toml ./conf.toml

COPY --from=build /TechTestApp TechTestApp

ENTRYPOINT [ "./TechTestApp" ]
