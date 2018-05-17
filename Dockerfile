FROM golang:alpine AS build

RUN apk add --no-cache curl git

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

WORKDIR $GOPATH/src/github.com/vibrato/TechTestApp

COPY . .

RUN ./build.sh \
    && cp -r ./dist /TechTestApp

FROM alpine:latest

WORKDIR /TechTestApp

COPY --from=build /TechTestApp .

ENTRYPOINT [ "./TechTestApp" ]