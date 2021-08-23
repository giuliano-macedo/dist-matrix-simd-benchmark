FROM alpine:3.14 as app
COPY . /app
WORKDIR /app
RUN apk add --no-cache g++ clang rust cargo python3 make py3-pip
RUN pip3 install pipenv
RUN pipenv install
RUN make datasets
RUN make -j16 compile_gcc compile_clang
RUN make compile_rust
CMD ["pipenv","run","benchmark"]