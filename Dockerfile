FROM golang:alpine AS build

RUN apk add --no-cache curl git alpine-sdk

ARG SWAGGER_UI_VERSION=3.20.9

RUN dir=$(mktemp -d) \
    && git clone https://github.com/go-swagger/go-swagger "$dir" \
    && cd "$dir" \
    && go install ./cmd/swagger \
    && curl -sfL https://github.com/swagger-api/swagger-ui/archive/v$SWAGGER_UI_VERSION.tar.gz | tar xz -C /tmp/ \
    && mv /tmp/swagger-ui-$SWAGGER_UI_VERSION /tmp/swagger \
    && sed -i 's#"https://petstore\.swagger\.io/v2/swagger\.json"#"./swagger.json"#g' /tmp/swagger/dist/index.html
RUN go env -w GO111MODULE=auto
RUN go get github.com/GeertJohan/go.rice/rice

WORKDIR $GOPATH/src/github.com/servian/TechChallengeApp

COPY go.mod go.sum $GOPATH/src/github.com/servian/TechChallengeApp/

RUN go mod tidy

COPY . .

RUN CGO_ENABLED="0" go build -ldflags="-s -w" -a -o /TechChallengeApp
RUN swagger generate spec -o /swagger.json \
 && cp /swagger.json ui/assets/swagger/ \
 && cp -R /tmp/swagger/dist ui/assets/swagger

RUN cd ui && rice append --exec /TechChallengeApp

FROM alpine:latest

WORKDIR /TechChallengeApp

COPY conf.toml ./conf.toml
COPY --from=build /TechChallengeApp TechChallengeApp

EXPOSE 3000
RUN echo "./TechChallengeApp updatedb; ./TechChallengeApp serve" > startapp.sh
ENTRYPOINT [ "/bin/sh", "startapp.sh"]
