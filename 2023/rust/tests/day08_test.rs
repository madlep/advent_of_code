use aoc2023::days::day08::{part1, part2};

const DATA: &str = "\
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)";

const DATA2: &str = "\
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)";

#[test]
fn part1_example_data() {
    assert_eq!(part1(DATA).map_err(|e| e.to_string()), Ok("2".to_string()));
    assert_eq!(part1(DATA2).map_err(|e| e.to_string()), Ok("6".to_string()));
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("part2 TODO".to_string())
    );
}
