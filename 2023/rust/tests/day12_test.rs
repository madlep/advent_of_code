use aoc2023::days::day12::{part1, part2};

const DATA: &str = "\
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1";

#[test]
fn part1_example_data() {
    assert_eq!(part1(DATA).map_err(|e| e.to_string()), Ok("21".to_string()));
}

#[test]
fn part2_example_data() {
    assert_eq!(
        part2(DATA).map_err(|e| e.to_string()),
        Ok("525152".to_string())
    );
}
