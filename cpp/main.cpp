#include "dataset.cpp"
#include <chrono>
#include <iostream>
#include <vector>

void dist_float64(double *a, double *b, int len, double *res) {
  double acc = 0.0;
  for (int i = 0; i < len; i++) {
    double d = b[i] - a[i];
    acc += d * d;
  }
  *res = sqrt(acc);
}

int main(int argc, const char **argv) {
  if (argc != 2) {
    cerr << " [Usage] " << argv[0] << " <dataset file path>" << endl;
    return -1;
  }
  auto dataset = Dataset::read_from_file(argv[1]);
  vector<double> ans(dataset.size * dataset.size, 0);
  auto start = chrono::high_resolution_clock::now();
  auto a = (double *)&(dataset.a[0]);
  auto ans_ptr = (double *)&(ans[0]);
  for (auto i = 0; i < dataset.size; i++) {
    auto b = (double *)&(dataset.b[0]);
    for (auto j = 0; j < dataset.size; j++) {
      dist_float64(a, b, dataset.dim, ans_ptr++);
      b += dataset.dim;
    }
    a += dataset.dim;
  }
  auto stop = chrono::high_resolution_clock::now();
  auto duration = chrono::duration_cast<chrono::microseconds>(stop - start);
  cout << duration.count() / 1e3 << endl;

  return 0;
}