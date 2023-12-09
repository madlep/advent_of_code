use aoc2023::days::day06::{part1, part2};

const DATA: &str = "\
Time:      7  15   30
Distance:  9  40  200";

#[test]
fn part1_example_data() {
    assert_eq!(
        part1(DATA).map_err(|e| e.to_string()),
        Ok("288".to_string())
    );
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("71503".to_string())
    );
}
