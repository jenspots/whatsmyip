FROM alpine:3.15.4 AS build
WORKDIR /app

# Install dependencies
RUN apk add gcc musl-dev

# yip is a single C file.
COPY yip.c yip.c

# Run GCC directly, skip CMake
RUN gcc -o yip yip.c -O3 -lpthread

FROM alpine:3.15.4 AS production
ENV THREADS 1
EXPOSE 80/tcp
WORKDIR /app

COPY --from=build /app/yip ./yip
RUN chmod +x ./yip

ENTRYPOINT ./yip -c ${THREADS} --verbose