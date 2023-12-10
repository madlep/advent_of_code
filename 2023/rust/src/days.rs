use std::error::Error;

pub mod day01;
pub mod day02;
pub mod day03;
pub mod day04;
pub mod day05;
pub mod day06;
pub mod day07;
pub mod day08;

pub type Day = u8;
pub type Part = u8;

pub fn run_day_part(day: Day, part: Part, data: &str) -> Result<String, Box<dyn Error>> {
    match (day, part) {
        (1, 1) => day01::part1(data),
        (1, 2) => day01::part2(data),
        (2, 1) => day02::part1(data),
        (2, 2) => day02::part2(data),
        (3, 1) => day03::part1(data),
        (3, 2) => day03::part2(data),
        (4, 1) => day04::part1(data),
        (4, 2) => day04::part2(data),
        (5, 1) => day05::part1(data),
        (5, 2) => day05::part2(data),
        (6, 1) => day06::part1(data),
        (6, 2) => day06::part2(data),
        (7, 1) => day07::part1(data),
        (7, 2) => day07::part2(data),
        (8, 1) => day08::part1(data),
        (8, 2) => day08::part2(data),
        (day_m, part_m) => panic!("Day {}, part {} is not implemented", day_m, part_m),
    }
}
