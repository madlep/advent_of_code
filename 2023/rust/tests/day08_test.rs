use aoc2023::days::day08::{part1, part2};

const DATA1: &str = "\
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)";

const DATA1_1: &str = "\
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)";

const DATA2: &str = "\
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)";

#[test]
fn part1_example_data() {
    assert_eq!(part1(DATA1).map_err(|e| e.to_string()), Ok("2".to_string()));
    assert_eq!(
        part1(DATA1_1).map_err(|e| e.to_string()),
        Ok("6".to_string())
    );
}

#[test]
fn part2_example_data() {
    assert_eq!(part2(DATA2).map_err(|e| e.to_string()), Ok("6".to_string()));
}
