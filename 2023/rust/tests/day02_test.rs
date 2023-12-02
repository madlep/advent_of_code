use aoc2023::days::day02::{part1, part2};

const DATA: &str = "\
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";

#[test]
fn part1_example_data() {
    assert_eq!(part1(DATA).map_err(|e| e.to_string()), Ok("8".to_string()));
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("2286".to_string())
    );
}
