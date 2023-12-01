use aoc2023::days::day01::{part1, part2};

const DATA: &str = "\
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet";

const DATA2: &str = "\
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen";

#[test]
fn part1_example_data() {
    assert_eq!(part1(DATA.to_string()), "142");
}

#[test]
fn part2_example_data() {
    assert_eq!(part2(DATA2.to_string()), "281");
}
