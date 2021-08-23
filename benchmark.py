from subprocess import check_output
from os import environ
import numpy as np
from tqdm import tqdm
from dataclasses import dataclass
from pathlib import Path
from typing import List


@dataclass
class Result:
    bin: str
    avg_time: int
    std_time: int
    min_time: int
    max_time: int


@dataclass
class ResultSet:
    results: List[Result]
    dataset: str

    def print(self):
        print(self.dataset)
        print(
            f"{'name':<20} {'avg_time':<10} {'std_time':<10} {'min_time':<10} {'max_time':<10}"
        )

        for res in self.results:
            print(
                f"{res.bin:<20} {res.avg_time:<10.2f} {res.std_time:<10.2f} {res.min_time:<10.2f} {res.max_time:<10.2f}"
            )


def run_benchmark(bin: str, dataset: str) -> int:
    stdout = check_output([bin, dataset]).strip()
    try:
        return float(stdout)
    except ValueError as err:
        raise RuntimeError(
            f"command '{bin}' returned non int value: f{stdout}"
        ) from err


BENCHMARK_ITERATIONS = int(environ.get("BENCHMARK_ITERATIONS", None))
if not BENCHMARK_ITERATIONS:
    raise RuntimeError("BENCHMARK_ITERATIONS env must be set")

result_sets = []
binaries = sorted(Path("./dist").glob("*"))
datasets = sorted(Path("./datasets").glob("*.bin"))
errs = set()
for dataset in tqdm(datasets, postfix="datasets"):
    results = []
    for bin in tqdm(binaries, postfix="binaries"):
        times = []
        for _ in tqdm(range(BENCHMARK_ITERATIONS), postfix="iterations"):
            try:
                times.append(run_benchmark(str(bin), str(dataset)))
            except Exception as err:
                errs.add((err, dataset, bin))
        if not times:
            continue
        times = np.array(times)
        results.append(
            Result(
                bin=bin.stem,
                avg_time=times.mean(),
                std_time=times.std(),
                min_time=times.min(),
                max_time=times.max(),
            )
        )
    results.sort(key=lambda r: r.min_time)
    result_sets.append(ResultSet(results=results, dataset=dataset))

if errs:
    print("The following errors occured:")
    print("-" * 16)
    for err, dataset, bin in errs:
        print(f"dataset:'{dataset}'")
        print(f"bin:'{bin}'")
        print(f"err:{str(err)}")
        print("-" * 16)

for rs in result_sets:
    rs.print()
