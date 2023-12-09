use aoc2023::days::day07::{part1, part2};

const DATA: &str = "\
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483";

#[test]
fn part1_example_data() {
    assert_eq!(
        part1(DATA).map_err(|e| e.to_string()),
        Ok("6440".to_string())
    );
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("5905".to_string())
    );
}
