// mod dataset;
use dataset::Dataset;
use structopt::StructOpt;

/// Generate a random dataset file containing two matrices of double values
#[derive(StructOpt)]
struct Cli {
    /// The number of points each matrix will have
    dataset_size: u64,
    /// The dimension of each point
    dataset_dim: u64,
    /// The path of the output file
    #[structopt(parse(from_os_str))]
    output: std::path::PathBuf,

    /// Random number generator seed, default value is based on system time
    #[structopt(short, long)]
    seed: Option<u64>,
}

fn main() {
    let args = Cli::from_args();

    let dataset = Dataset::random(args.dataset_dim, args.dataset_size, args.seed);
    dataset.write_to_file(args.output);
}
