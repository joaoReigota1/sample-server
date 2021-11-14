# syntax=docker/dockerfile:1

FROM golang:1.16-alpine
RUN mkdir /app


WORKDIR /app

COPY ./ ./
RUN go mod download

RUN go build -o /server

EXPOSE 4000

CMD [ "/server" ,"start", "-p", "4000"]