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
* python >= 3.6
* pipenv
* g++
* clang
* cargo

## Instalation
### With docker
Just run `docker-compose run app` ;)

### Without docker
Just run `make -j16` ;).

## My Results (CPU: i5-10300h, 100 Iterations)
### Dataset 1000x500
name                 avg_time   std_time   min_time   max_time  
gcc_o3               430.25     1.72       427.36     435.66    
gcc_avx1o3           432.59     1.55       428.89     437.19    
rust_o3              436.54     1.94       432.75     441.52    
clang_o2             436.84     3.09       433.22     457.52    
clang_o3             439.35     5.73       433.70     474.30    
gcc_avx1o2           437.71     1.82       434.95     448.06    
rust_o2              439.41     1.97       435.04     446.17    
gcc_o2               439.22     1.76       435.64     447.56    
rust_avx2o3          481.44     245.66     437.38     2437.05   
rust_avx1o3          441.42     2.34       437.83     457.87    
clang_avx2o3         444.03     3.19       438.51     459.55    
clang_avx1o2         443.27     3.92       438.70     462.62    
clang_avx2o2         443.19     2.15       439.02     455.93    
clang_avx1o3         442.58     1.96       439.21     450.36    
rust_avx2o2          444.05     1.64       440.22     448.28    
rust_avx1o2          443.87     1.85       440.32     449.97   

### Dataset 1500x100
name                 avg_time   std_time   min_time   max_time  
gcc_o3               150.10     1.30       148.06     153.78    
gcc_avx1o3           156.69     1.52       153.89     161.49    
rust_o3              161.81     1.43       158.76     165.91    
clang_o2             163.77     1.19       161.18     166.64    
clang_o3             164.17     1.62       161.68     171.23    
gcc_avx1o2           167.62     1.35       164.62     171.55    
rust_o2              168.33     1.27       165.90     171.26    
gcc_o2               170.77     1.28       168.15     174.65    
rust_avx2o3          172.82     1.49       170.05     175.95    
rust_avx1o3          172.87     1.44       170.19     177.11    
rust_avx1o2          177.33     1.47       174.58     182.88    
rust_avx2o2          177.01     1.20       174.79     181.92    
clang_avx1o2         177.79     2.18       175.07     195.51    
clang_avx2o2         177.70     1.27       175.09     183.14    
clang_avx2o3         178.34     1.27       175.74     182.39    
clang_avx1o3         178.23     1.39       175.86     184.69    

### Dataset 1500x25
name                 avg_time   std_time   min_time   max_time  
gcc_o3               30.56      0.73       29.27      32.49     
clang_o2             32.45      0.84       30.85      34.64     
gcc_avx1o3           32.19      0.75       31.13      34.51     
clang_o3             32.59      0.87       31.19      36.02     
gcc_avx1o2           34.48      0.66       33.32      36.15     
rust_o3              34.93      0.75       33.38      37.02     
gcc_o2               35.86      0.70       34.56      38.16     
clang_avx2o2         36.16      0.72       34.75      38.12     
clang_avx1o3         36.02      0.77       34.80      38.12     
clang_avx1o2         36.12      0.75       34.83      37.80     
clang_avx2o3         36.14      0.68       34.85      37.78     
rust_o2              36.10      0.80       34.88      38.79     
rust_avx1o3          38.13      1.81       36.13      53.67     
rust_avx2o3          37.80      0.78       36.54      40.02     
rust_avx1o2          39.66      0.80       38.28      42.08     
rust_avx2o2          39.69      0.83       38.33      41.99   
