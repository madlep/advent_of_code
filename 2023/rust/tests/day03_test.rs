use aoc2023::days::day03::{part1, part2};

const DATA: &str = "\
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

#[test]
fn part1_example_data() {
    assert_eq!(
        part1(DATA).map_err(|e| e.to_string()),
        Ok("4361".to_string())
    );
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("467835".to_string())
    );
}
