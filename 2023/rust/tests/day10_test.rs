use aoc2023::days::day10::{part1, part2};

const DATA1: &str = "\
.....
.S-7.
.|.|.
.L-J.
.....";

const DATA2: &str = "\
-L|F7
7S-7|
L|7||
-L-J|
L|-JF";

const DATA3: &str = "\
..F7.
.FJ|.
SJ.L7
|F--J
LJ...";

const DATA4: &str = "\
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ";

#[test]
fn part1_example_data() {
    assert_eq!(part1(DATA1).map_err(|e| e.to_string()), Ok("4".to_string()));
    assert_eq!(part1(DATA2).map_err(|e| e.to_string()), Ok("4".to_string()));
    assert_eq!(part1(DATA3).map_err(|e| e.to_string()), Ok("8".to_string()));
    assert_eq!(part1(DATA4).map_err(|e| e.to_string()), Ok("8".to_string()));
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA1).map_err(|e| e.to_string()),
        Ok("TODO".to_string())
    );
}
