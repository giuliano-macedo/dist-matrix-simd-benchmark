#include <chrono>
#include <cmath>
#include <iostream>
#include <random>
#include <vector>

typedef std::vector<double> Point;

void dist_float64(double *a, double *b, int len, double *res) {
  double acc = 0.0;
  for (int i = 0; i < len; i++) {
    double d = b[i] - a[i];
    acc += d * d;
  }
  *res = sqrt(acc);
}
void set_rand_vec(double *a, int dimension) {
  for (int i = 0; i < dimension; i++) {
    a[i] = rand();
  }
}

typedef struct {
  Point a;
  Point b;
} PairOfPoint;

using namespace std::chrono;

int main() {
  std::vector<PairOfPoint> dataset(DATASET_SIZE,
                                   {Point(DATASET_DIM), Point(DATASET_DIM)});
  for (int i = 0; i < DATASET_SIZE; i++) {
    set_rand_vec(&(dataset[i].a[0]), DATASET_DIM);
    set_rand_vec(&(dataset[i].b[0]), DATASET_DIM);
  }
  std::vector<double> ans(DATASET_SIZE, 0);
  auto start = std::chrono::high_resolution_clock::now();
  for (int i = 0; i < DATASET_SIZE; i++) {
    double *pa = &(dataset[i].a[0]);
    double *pb = &(dataset[i].b[0]);
    dist_float64(pa, pb, DATASET_DIM, &(ans[i]));
  }
  auto stop = high_resolution_clock::now();
  auto duration = duration_cast<microseconds>(stop - start);
  std::cout << duration.count() / 1e3 << std::endl;
}