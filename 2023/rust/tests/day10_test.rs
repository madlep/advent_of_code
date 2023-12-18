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

const DATA2_1: &str = "\
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........";

const DATA2_2: &str = "\
 ..........
.S------7.
.|F----7|.
.||....||.
.||....||.
.|L-7F-J|.
.|..||..|.
.L--JL--J.
..........";

const DATA2_3: &str = "\
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...";

const DATA2_4: &str = "\
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L";

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
        part2(DATA2_1).map_err(|e| e.to_string()),
        Ok("4".to_string())
    );
    assert_eq!(
        part2(DATA2_2).map_err(|e| e.to_string()),
        Ok("4".to_string())
    );
    assert_eq!(
        part2(DATA2_3).map_err(|e| e.to_string()),
        Ok("8".to_string())
    );
    assert_eq!(
        part2(DATA2_4).map_err(|e| e.to_string()),
        Ok("10".to_string())
    );
}
