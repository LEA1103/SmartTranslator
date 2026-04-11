FROM ubuntu:22.04

RUN apt update && apt install -y qtbase5-dev cmake g++

WORKDIR /app
COPY . .

RUN cmake -B build && make -C build

CMD ["./build/smart-translator"]
