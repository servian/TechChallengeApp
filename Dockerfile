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

WORKDIR $GOPATH/src/github.com/servian/TechChallengeApp

COPY go.mod go.sum $GOPATH/src/github.com/servian/TechChallengeApp/

RUN go mod tidy

COPY . .

RUN go build -ldflags="-s -w" -a -o /TechChallengeApp
RUN swagger generate spec -o /swagger.json

FROM alpine:latest

WORKDIR /TechChallengeApp

COPY assets ./assets
COPY conf.toml /opt/conf.toml

COPY --from=build /tmp/swagger/dist ./assets/swagger
COPY --from=build /swagger.json ./assets/swagger/swagger.json
COPY --from=build /TechChallengeApp TechChallengeApp

EXPOSE 3000

ENTRYPOINT [ "./TechChallengeApp" ]
