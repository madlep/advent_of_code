use aoc2023::days::day01::{part1, part2};

const DATA: &str = "\
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet";

const BAD_DATA: &str = "\
1abc2
pqr3stu8vwx
abcdefBAD
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

const BAD_DATA2: &str = "\
two1nine
eightwothree
abcone2threexyz
xtwone3four
abcdefBAD
4nineeightseven2
zoneight234
7pqrstsixteen";

#[test]
fn part1_example_data() {
    assert_eq!(
        part1(DATA).map_err(|e| e.to_string()),
        Ok("142".to_string())
    );
}

#[test]
fn part1_fails_with_bad_data() {
    assert_eq!(
        part1(BAD_DATA).map_err(|e| e.to_string()),
        Err("couldn't find number in `abcdefBAD`".to_string())
    );
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA2).map_err(|e| e.to_string()),
        Ok("281".to_string())
    );
}

#[test]
fn part2_fails_with_bad_data() {
    assert_eq!(
        part2(BAD_DATA2).map_err(|e| e.to_string()),
        Err("couldn't find number in `abcdefBAD`".to_string())
    );
}
