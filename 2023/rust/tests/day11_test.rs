use aoc2023::days::day11::{part1, part2};

const DATA: &str = "\
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....";

#[test]
fn part1_example_data() {
    assert_eq!(
        part1(DATA).map_err(|e| e.to_string()),
        Ok("374".to_string())
    );
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("TODO".to_string())
    );
}
