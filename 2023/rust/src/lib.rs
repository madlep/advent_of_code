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
