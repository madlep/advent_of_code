use aoc2023::days::{Day, Part};

use std::error::Error;
use std::path::PathBuf;

use clap::Parser;

#[derive(Parser)]
struct Cli {
    #[arg(short, long, value_parser = clap::value_parser!(u8).range(1..=25))]
    day: Day,

    #[arg(short, long, value_parser = clap::value_parser!(u8).range(1..=2))]
    part: Part,

    #[arg(short, long, value_name = "FILE")]
    file: Option<PathBuf>,
}

fn main() -> Result<(), Box<dyn Error>> {
    let (day, part, file_path) = parse_args();

    aoc2023::run(day, part, file_path).map(|output| println!("{}", output))
}

fn parse_args() -> (Day, Part, PathBuf) {
    let args = Cli::parse();
    let day = args.day;
    let part = args.part;
    let file_path = build_file_path(args.file, day);
    (day, part, file_path)
}

fn build_file_path(file_path_arg: Option<PathBuf>, day: Day) -> PathBuf {
    if let Some(input_file) = file_path_arg.as_deref() {
        PathBuf::from(input_file)
    } else {
        let day_file_name = format!("day{:02}.txt", day);
        ["./data", day_file_name.as_str()].iter().collect()
    }
}
