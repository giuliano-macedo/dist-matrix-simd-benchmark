# original clang command i couldnt make it work : 
# clang++ -mavx2 -masm=intel -mno-red-zone -mstackrealign -mllvm -inline-threshold=1000 \
# 	-fno-asynchronous-unwind-tables -fno-exceptions -fno-rtti -c main.cpp -o dist/main_clang
ALL:benchmark

include .env


DATASET_GEN=cargo run --release --manifest-path=dataset-gen/Cargo.toml

RUST_RELEASE_BIN= ./rust/target/release/f64-dist-benchmark
CARGO_BUILD=cargo build --release --manifest-path=rust/Cargo.toml && cp ${RUST_RELEASE_BIN} ./dist/$@
RUSTFLAGS_AVX1 = -C target-cpu=native -C target-feature=+avx,+fma
RUSTFLAGS_AVX2 = -C target-cpu=native -C target-feature=+avx2,+fma
RUSTFLAGS_O2 = -C opt-level=2
RUSTFLAGS_O3 = -C opt-level=3

CPP_SRC= cpp/main.cpp
CFLAGS = -std=c++11
GCC = g++ ${CFLAGS}
CLANG = clang++ ${CFLAGS}
CFLAGS_AVX1 = -mfma -mavx
CFLAGS_AVX2 = -mfma -mavx2

## EDIT HERE TO CHANGE DATASETS
datasets:
	@echo "generating datasets..."
	mkdir -p datasets
	${DATASET_GEN} 1500 25   datasets/dataset-1500x25.bin -s 42
	${DATASET_GEN} 1500 100 datasets/dataset-1500x100.bin -s 42
	${DATASET_GEN} 1000 500 datasets/dataset-1000x500.bin -s 42

dist:
	mkdir -p dist

rust_avx1o2:dist
	RUSTFLAGS="${RUSTFLAGS_O2} ${RUSTFLAGS_AVX1}" ${CARGO_BUILD}

rust_avx1o3:dist
	RUSTFLAGS="${RUSTFLAGS_O3} ${RUSTFLAGS_AVX1}" ${CARGO_BUILD}

rust_avx2o2:dist
	RUSTFLAGS="${RUSTFLAGS_O2} ${RUSTFLAGS_AVX2}" ${CARGO_BUILD}

rust_avx2o3:dist
	RUSTFLAGS="${RUSTFLAGS_O3} ${RUSTFLAGS_AVX2}" ${CARGO_BUILD}

rust_o2:dist
	RUSTFLAGS="${RUSTFLAGS_O2}" ${CARGO_BUILD}
rust_o3:dist
	RUSTFLAGS="${RUSTFLAGS_O3}" ${CARGO_BUILD}

clang_avx1o2:dist
	${CLANG} ${CFLAGS_AVX1} -O2 ${CPP_SRC} -o dist/$@

clang_avx1o3:dist
	${CLANG} ${CFLAGS_AVX1} -O3 ${CPP_SRC} -o dist/$@

clang_avx2o2:dist
	${CLANG} ${CFLAGS_AVX2} -O2 ${CPP_SRC} -o dist/$@

clang_avx2o3:dist
	${CLANG} ${CFLAGS_AVX2} -O3 ${CPP_SRC} -o dist/$@

clang_o2:dist
	${CLANG} -O2 ${CPP_SRC} -o dist/$@

clang_o3:dist
	${CLANG} -O3 ${CPP_SRC} -o dist/$@

gcc_o2:dist
	${GCC} -O2 ${CPP_SRC} -o dist/$@

gcc_o3:dist
	${GCC} -O3 ${CPP_SRC} -o dist/$@

gcc_avx1o2:dist
	${GCC} ${CFLAGS_AVX1} -O2 ${CPP_SRC} -o dist/$@

gcc_avx1o3:dist
	${GCC} ${CFLAGS_AVX1} -O3 ${CPP_SRC} -o dist/$@

gcc_avx2o2:dist
	${GCC} ${CFLAGS_AVX2} -O2 ${CPP_SRC} -o dist/$@

gcc_avx2o3:dist
	${GCC} ${CFLAGS_AVX2} -O3 ${CPP_SRC} -o dist/$@

clean:
	rm -rf dist datasets

compile_rust:rust_o2 rust_o3 rust_avx1o2 rust_avx1o3 rust_avx2o2 rust_avx2o3 
compile_gcc:gcc_o2 gcc_o3 gcc_avx1o2 gcc_avx1o3 gcc_avx1o2 gcc_avx1o3
compile_clang: clang_o3 clang_o2 clang_avx1o2 clang_avx1o3 clang_avx2o2 clang_avx2o3
compile:compile_rust compile_gcc compile_clang

benchmark:compile datasets
	pipenv install
	pipenv run benchmark