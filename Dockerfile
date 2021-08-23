FROM alpine:3.14 as app
COPY . /app
WORKDIR /app
RUN apk add --no-cache musl-dev linux-headers g++ clang rust cargo python3 python3-dev make py3-pip
RUN pip3 install pipenv
RUN pipenv install --system
RUN make datasets
RUN make -j16 compile_gcc compile_clang
RUN make compile_rust
CMD ["python3","benchmark.py"]