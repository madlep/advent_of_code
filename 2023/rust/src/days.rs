pub mod day01;

pub type Day = u8;
pub type Part = u8;

pub fn run_day_part(day: Day, part: Part, data: String) -> String {
    match (day, part) {
        (1, 1) => day01::part1(data),
        (1, 2) => day01::part2(data),
        (day_m, part_m) => panic!("Day {}, part {} is not implemented", day_m, part_m),
    }
}
