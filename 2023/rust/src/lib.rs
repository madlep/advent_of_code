use crate::days::*;

use std::error::Error;
use std::fs::File;
use std::io::Read;
use std::path::PathBuf;

pub mod days;

pub fn run(day: Day, part: Part, path: PathBuf) -> Result<String, Box<dyn Error>> {
    let data = load_data(path)?;
    days::run_day_part(day, part, data.as_str())
}

fn load_data(file_path: PathBuf) -> Result<String, std::io::Error> {
    let mut file = File::open(file_path)?;
    let mut data = String::new();
    file.read_to_string(&mut data)?;
    Ok(data)
}

#[derive(thiserror::Error, Debug, PartialEq)]
#[error("error parsing: `{0}`")]
struct ParseError(String);

#[derive(Hash, Eq, PartialEq, Clone, Copy, Debug)]
struct Coord {
    x: i64,
    y: i64,
}

impl Coord {
    fn new(x: i64, y: i64) -> Self {
        Coord { x, y }
    }

    fn translate(&self, x: i64, y: i64) -> Self {
        Self {
            x: self.x + x,
            y: self.y + y,
        }
    }

    fn neighbours(&self) -> Vec<Self> {
        vec![
            // north
            Self::new(self.x, self.y - 1),
            // west
            Self::new(self.x - 1, self.y),
            // east
            Self::new(self.x + 1, self.y),
            // south
            Self::new(self.x, self.y + 1),
        ]
    }
}
