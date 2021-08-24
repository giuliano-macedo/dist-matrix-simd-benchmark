// mod dataset;
use dataset::Dataset;

use std::env;
use std::path::PathBuf;
use std::time::Instant;

#[inline(always)]
fn dist(a: &[f64], b: &[f64]) -> f64 {
    a.iter()
        .zip(b.iter())
        .map(|(x, y)| {
            let d = y - x;
            d * d
        })
        .sum::<f64>()
        .sqrt()
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        panic!("[USAGE] {} <dataset file path>", &args[0]);
    }

    let dataset = Dataset::read_from_file(PathBuf::from(&args[1]));

    let now = Instant::now();
    let mut ans: Vec<f64> = Vec::new();
    ans.reserve((dataset.dim * dataset.dim) as usize);
    for a in dataset.iter_a() {
        for b in dataset.iter_b() {
            ans.push(dist(a, b));
        }
    }
    // let ans: Vec<f64> = dataset
    //     .iter_a()
    //     .map(|a| dataset.iter_b().map(move |b| dist(a, b)))
    //     .flatten()
    //     .collect();
    println!("{}", (now.elapsed().as_micros() as f64) / 1e3);
}
