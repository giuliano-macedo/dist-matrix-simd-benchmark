use rand::rngs::StdRng;
use rand::{Rng, SeedableRng};
use std::time::{SystemTime, UNIX_EPOCH};

use std::convert::TryInto;
use std::fs::File;
use std::io::{BufReader, BufWriter, Read, Write};

#[derive(Debug)]
struct Matrix(Vec<f64>);

#[derive(Debug)]
pub struct Dataset {
    pub dim: u64,
    pub size: u64,
    a: Matrix,
    b: Matrix,
}

const BUFFSIZE: usize = 4000;

impl Matrix {
    fn random(dimsize: u64, rng: &mut StdRng) -> Self {
        Self((0..dimsize).map(|_| rng.gen::<f64>()).collect())
    }

    fn read_bytes(reader: &mut dyn Read, dimsize: u64) -> Self {
        let mut buff: [u8; 8] = [0; 8];
        Self(
            (0..dimsize)
                .map(|_| {
                    reader.read(&mut buff).expect("Couldn't read");
                    f64::from_ne_bytes(buff.try_into().expect("couldn't fit buff into array"))
                })
                .collect(),
        )
    }

    fn write_bytes(&self, writer: &mut dyn Write) {
        for x in self.0.iter() {
            writer.write(&x.to_ne_bytes()).expect("write failed");
        }
    }
}

impl Dataset {
    pub fn random(dim: u64, size: u64, seed: Option<u64>) -> Self {
        let mut rng = StdRng::seed_from_u64(match seed {
            Some(s) => s,
            None => SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("Time went backwards")
                .as_nanos() as u64,
        });
        let dimsize = dim * size;
        Self {
            dim,
            size,
            a: Matrix::random(dimsize, &mut rng),
            b: Matrix::random(dimsize, &mut rng),
        }
    }
    pub fn read_from_file(file_name: std::path::PathBuf) -> Self {
        let file = File::open(file_name).expect("Couldn't open file");
        let mut reader = BufReader::with_capacity(BUFFSIZE, file);
        let mut buffer: [u8; 16] = [0; 16];
        reader.read_exact(&mut buffer).expect("couldn't read");
        let dim = u64::from_ne_bytes(buffer[0..8].try_into().expect("couldn't fit buff"));
        let size = u64::from_ne_bytes(buffer[8..16].try_into().expect("couldn't fit buff"));

        assert!(dim > 0);
        assert!(size > 0);

        let dimsize = dim * size;

        let a = Matrix::read_bytes(&mut reader, dimsize);
        let b = Matrix::read_bytes(&mut reader, dimsize);

        Self { dim, size, a, b }
    }
    pub fn write_to_file(&self, file_name: std::path::PathBuf) -> () {
        let file = File::create(file_name).expect("create failed");
        let mut writer = BufWriter::with_capacity(BUFFSIZE, file);
        writer
            .write_all(&self.dim.to_ne_bytes())
            .expect("write failed");
        writer
            .write_all(&self.size.to_ne_bytes())
            .expect("write failed");
        self.a.write_bytes(&mut writer);
        self.b.write_bytes(&mut writer);
    }

    pub fn iter_a(&self) -> std::slice::ChunksExact<f64> {
        self.a.0.chunks_exact(self.dim as usize)
    }
    pub fn iter_b(&self) -> std::slice::ChunksExact<f64> {
        self.b.0.chunks_exact(self.dim as usize)
    }
}
