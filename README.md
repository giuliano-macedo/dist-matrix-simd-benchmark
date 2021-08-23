# GCC VS Clang VS Rust SIMD pair wise distance matrix benchmark

This repo contains a benchmark comparing gcc,clang and rust performance with 
optimization levels 2 and 3, as well as using AVX1 and AVX2 in the pairwise distance matrix
calculation in a random seeded dataset.

## How it works
The `benchmark.py` scripts runs every binary in `dist` with every dataset ending with .bin in `datasets`, and the `Makefile`
compiles every combination of languages,compilers and compiler arguments and put the binaries inside dist.

The rust project `dataset-gen` generates the dataset files, and the Makefile runs this project to generate datasets and put them in the `datasets` folder.

## How to customize the benchmark
Edit the rule `datasets` in the `Makefile` to change the datasets to benchmark, and enable and disable any rule to change the benchmark parameters,
as well as editing the `.env` to change the iterations of the benchmark.
## Pre-requisites
#### With docker
* docker
* docker-compose
### Without docker
* make
* python >= 3.6
* pipenv
* g++
* clang
* cargo

## Running the benchmark
### With docker
Just run `docker-compose run app` ;)

### Without docker
Just run `make -j16` ;).

## My Results (CPU: i5-10300h, 100 Iterations)
## Dataset 1000x500
|**name**            |**avg_time**   |**std_time**   |**min_time**   |**max_time**   |
|--------------------|---------------|---------------|---------------|---------------|
|gcc_o3              |431.57         |2.53           |426.88         |447.82         |
|gcc_avx1o3          |433.90         |2.15           |429.96         |443.86         |
|rust_o3             |437.25         |2.98           |432.71         |458.39         |
|clang_o2            |437.88         |2.91           |433.69         |450.30         |
|clang_o3            |437.65         |2.41           |433.82         |452.70         |
|gcc_avx1o2          |438.98         |2.14           |434.55         |446.45         |
|rust_o2             |439.56         |1.91           |435.72         |444.11         |
|gcc_o2              |440.53         |2.06           |436.91         |449.00         |
|rust_avx1o3         |442.25         |3.21           |437.32         |460.21         |
|rust_avx2o3         |442.04         |2.62           |437.65         |453.95         |
|clang_avx1o2        |443.14         |1.67           |438.30         |446.83         |
|rust_avx2o2         |444.57         |2.16           |439.17         |449.78         |
|clang_avx2o2        |447.62         |6.25           |439.56         |463.37         |
|rust_avx1o2         |444.60         |2.10           |439.60         |449.86         |
|clang_avx2o3        |444.29         |2.69           |439.75         |457.73         |
|clang_avx1o3        |444.31         |2.43           |440.15         |458.31         |
## Dataset 1500x100
|**name**            |**avg_time**   |**std_time**   |**min_time**   |**max_time**   |
|--------------------|---------------|---------------|---------------|---------------|
|gcc_o3              |150.33         |1.49           |147.74         |154.21         |
|gcc_avx1o3          |156.81         |1.41           |153.85         |161.02         |
|rust_o3             |161.98         |2.06           |159.39         |176.06         |
|clang_o2            |164.24         |1.87           |161.34         |178.10         |
|clang_o3            |164.46         |1.30           |161.66         |167.92         |
|gcc_avx1o2          |167.42         |1.39           |164.50         |171.43         |
|rust_o2             |168.79         |1.54           |165.64         |172.85         |
|gcc_o2              |170.77         |1.18           |168.14         |173.96         |
|rust_avx1o3         |173.35         |1.61           |169.47         |178.43         |
|rust_avx2o3         |173.05         |1.56           |169.99         |177.20         |
|rust_avx1o2         |177.71         |1.59           |174.56         |181.73         |
|rust_avx2o2         |177.75         |1.34           |174.93         |181.12         |
|clang_avx2o3        |178.42         |1.46           |175.25         |182.46         |
|clang_avx1o2        |177.93         |1.37           |175.25         |181.62         |
|clang_avx2o2        |177.75         |1.31           |175.51         |181.27         |
|clang_avx1o3        |178.64         |1.48           |175.75         |182.26         |
## Dataset 1500x25
|**name**            |**avg_time**   |**std_time**   |**min_time**   |**max_time**   |
|--------------------|---------------|---------------|---------------|---------------|
|gcc_o3              |30.59          |0.73           |29.42          |33.01          |
|clang_o2            |32.36          |0.81           |30.93          |34.67          |
|gcc_avx1o3          |32.42          |0.84           |31.07          |34.91          |
|clang_o3            |32.58          |0.85           |31.12          |34.69          |
|gcc_avx1o2          |34.68          |0.77           |33.23          |36.51          |
|rust_o3             |34.98          |0.80           |33.49          |37.51          |
|gcc_o2              |36.00          |0.76           |34.54          |38.85          |
|rust_o2             |36.07          |0.80           |34.77          |38.65          |
|clang_avx2o2        |36.17          |0.80           |34.78          |38.57          |
|clang_avx1o2        |36.18          |0.80           |34.83          |38.04          |
|clang_avx2o3        |36.24          |0.73           |34.86          |38.47          |
|clang_avx1o3        |36.15          |0.69           |34.90          |37.70          |
|rust_avx2o3         |37.76          |0.82           |36.05          |39.85          |
|rust_avx1o3         |37.82          |0.91           |36.22          |39.92          |
|rust_avx1o2         |39.90          |0.97           |38.13          |42.89          |
|rust_avx2o2         |39.71          |0.78           |38.30          |41.50          |