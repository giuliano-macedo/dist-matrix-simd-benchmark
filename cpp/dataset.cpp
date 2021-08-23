#include <fstream>
#include <math.h>
#include <vector>

using namespace std;

#define BUFFSIZE 4000

typedef long unsigned int u64;

void read_matrix(ifstream &file, vector<double> &mat, u64 dimsize) {
  mat.reserve(dimsize);
  double x;
  for (auto _ = 0; _ < dimsize; _++) {
    file.read((char *)&x, 8);
    mat.push_back(x);
  }
}

struct Dataset {
  u64 dim;
  u64 size;
  vector<double> a;
  vector<double> b;

  static Dataset read_from_file(const string file_name) {
    char buff[BUFFSIZE];
    Dataset ans = {0, 0, {}, {}};
    ifstream file(file_name);
    file.rdbuf()->pubsetbuf(buff, sizeof buff);
    if (!file) {
      throw new runtime_error("Cannot open file!");
    }
    file.read((char *)&(ans.dim), 8);
    file.read((char *)&(ans.size), 8);
    if (ans.dim == 0 || ans.size == 0) {
      throw new runtime_error("dim or size is zero!");
    }
    u64 dimsize = ans.dim * ans.size;

    read_matrix(file, ans.a, dimsize);
    read_matrix(file, ans.b, dimsize);

    file.close();

    return ans;
  }
};
