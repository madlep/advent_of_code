use aoc2023::days::day09::{part1, part2};

const DATA: &str = "\
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45";

#[test]
fn part1_example_data() {
    assert_eq!(
        part1(DATA).map_err(|e| e.to_string()),
        Ok("114".to_string())
    );
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("part2 todo".to_string())
    );
}
