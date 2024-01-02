use std::collections::HashMap;

use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{newline, space1, u64 as nom_u64},
    combinator::{map, value},
    multi::{many0, separated_list0},
    sequence::separated_pair,
    IResult,
};

use crate::ParseError;
pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let condition_records = parse(data)?;

    Ok(condition_records
        .iter()
        .map(|dr| dr.permutation_count())
        .sum::<u64>()
        .to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let condition_records = parse(data)?;

    Ok(condition_records
        .iter()
        .map(|dr| dr.unfold())
        .enumerate()
        .map(|(_, dr)| dr.permutation_count())
        .sum::<u64>()
        .to_string())
}

#[derive(Debug)]
struct ConditionRecord {
    springs: Vec<Spring>,
    checksums: Vec<Checksum>,
}

impl ConditionRecord {
    fn permutation_count(&self) -> u64 {
        permutation_count(
            &mut HashMap::new(),
            &self.springs,
            &self.checksums,
            Inactive,
        )
    }

    fn unfold(&self) -> Self {
        let mut springs = vec![];
        for _ in 0..5 {
            springs.append(&mut self.springs.clone());
            springs.push(Unknown);
        }
        springs.pop();

        let mut checksums = vec![];
        for _ in 0..5 {
            checksums.append(&mut self.checksums.clone());
        }

        Self { springs, checksums }
    }
}

type Memo<'a> = HashMap<(&'a [Spring], &'a [Checksum], Checksum), u64>;

fn permutation_count<'a>(
    memo: &mut Memo<'a>,
    springs: &'a [Spring],
    checksums: &'a [Checksum],
    partial: Checksum,
) -> u64 {
    if let Some(result) = memo.get(&(springs, checksums, partial)) {
        *result
    } else {
        let result = if is_possible(springs, &checksums, partial) {
            match_permutation(memo, springs, checksums, partial)
        } else {
            0
        };

        memo.insert((springs, checksums, partial), result);
        result
    }
}

fn match_permutation<'a>(
    memo: &mut Memo<'a>,
    springs: &'a [Spring],
    checksums: &'a [Checksum],
    partial: Checksum,
) -> u64 {
    match (springs, checksums, partial) {
        ([], [], Inactive) => 1,

        // if not in a checksum
        (ss, cs, Inactive) => match ss.split_first() {
            Some((Operational, ss2)) => permutation_count(memo, ss2, cs, Inactive),
            Some((Damaged, _)) => match cs.split_first() {
                Some((c, cs2)) => permutation_count(memo, ss, cs2, *c),
                None => 0,
            },
            Some((Unknown, ss2)) => {
                let operational = permutation_count(memo, ss2, cs, Inactive);
                let damaged = match cs.split_first() {
                    Some((c, cs2)) => permutation_count(memo, ss, cs2, *c),
                    None => 0,
                };
                operational + damaged
            }
            None => 0,
        },

        // if in a checksum, at the end
        (ss, cs, Active(1)) => match ss {
            [Operational, ..] => 0,
            [Damaged | Unknown, Operational | Unknown, ss2 @ ..] => {
                permutation_count(memo, ss2, cs, Inactive)
            }
            [Damaged | Unknown, Damaged, ..] => 0,
            [Damaged | Unknown] => permutation_count(memo, &[], cs, Inactive),
            [] => 0,
        },

        // if in checksm, not at the end
        (ss, cs, Active(n @ 1..)) => match ss {
            [Operational, ..] => 0,
            [Damaged | Unknown, ss2 @ ..] => permutation_count(memo, ss2, cs, Active(n - 1)),
            [] => 0,
        },

        _ => panic!("{:?} {:?} {:?}", springs, checksums, partial),
    }
}

fn is_possible(springs: &[Spring], checksums: &[Checksum], partial: Checksum) -> bool {
    let mut cs = 0;
    for c in checksums.iter() {
        if let Active(n) = c {
            cs += n;
        }
    }
    if let Active(n) = partial {
        cs += n;
    }

    if cs > springs.len() as u64 {
        return false;
    }

    let mut d = 0;
    let mut u = 0;
    for s in springs.iter() {
        match s {
            Operational => (),
            Damaged => d += 1,
            Unknown => u += 1,
        }
    }

    cs >= d && cs <= d + u
}

#[derive(Clone, PartialEq, Eq, Hash)]
enum Spring {
    Operational,
    Damaged,
    Unknown,
}

impl std::fmt::Debug for Spring {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.to_string())
    }
}

impl ToString for Spring {
    fn to_string(&self) -> String {
        match self {
            Operational => ".".to_string(),
            Damaged => "#".to_string(),
            Unknown => "?".to_string(),
        }
    }
}

use Spring::*;

#[derive(Clone, Copy, PartialEq, Eq, Hash)]
enum Checksum {
    Active(u64),
    Inactive,
}
use Checksum::*;

impl std::fmt::Debug for Checksum {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Active(c) => f.write_str(&c.to_string()),
            Inactive => f.write_str("-"),
        }
    }
}

fn parse(s: &str) -> Result<Vec<ConditionRecord>, ParseError> {
    let (rest, reports) = condition_records(s).map_err(|e| ParseError(e.to_string()))?;
    debug_assert_eq!(rest.trim(), "");
    Ok(reports)
}

fn condition_records(s: &str) -> IResult<&str, Vec<ConditionRecord>> {
    separated_list0(newline, condition_record)(s)
}

fn condition_record(s: &str) -> IResult<&str, ConditionRecord> {
    map(
        separated_pair(springs, space1, checksums),
        |(springs, checksums)| ConditionRecord { springs, checksums },
    )(s)
}

fn springs(s: &str) -> IResult<&str, Vec<Spring>> {
    many0(spring)(s)
}

fn spring(s: &str) -> IResult<&str, Spring> {
    alt((
        value(Spring::Operational, tag(".")),
        value(Spring::Damaged, tag("#")),
        value(Spring::Unknown, tag("?")),
    ))(s)
}

fn checksums(s: &str) -> IResult<&str, Vec<Checksum>> {
    separated_list0(tag(","), checksum)(s)
}

fn checksum(s: &str) -> IResult<&str, Checksum> {
    map(nom_u64, Active)(s)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_permutation_count_1() {
        let (_, rep) = condition_record("???.### 1,1,3").unwrap();
        assert_eq!(rep.permutation_count(), 1);
        assert_eq!(rep.unfold().permutation_count(), 1);

        let (_, rep) = condition_record(".??..??...?##. 1,1,3").unwrap();
        assert_eq!(rep.permutation_count(), 4);
        assert_eq!(rep.unfold().permutation_count(), 16384);

        let (_, rep) = condition_record("?#?#?#?#?#?#?#? 1,3,1,6").unwrap();
        assert_eq!(rep.permutation_count(), 1);
        assert_eq!(rep.unfold().permutation_count(), 1);

        let (_, rep) = condition_record("????.#...#... 4,1,1").unwrap();
        assert_eq!(rep.permutation_count(), 1);
        assert_eq!(rep.unfold().permutation_count(), 16);

        let (_, rep) = condition_record("????.######..#####. 1,6,5").unwrap();
        assert_eq!(rep.permutation_count(), 4);
        assert_eq!(rep.unfold().permutation_count(), 2500);

        let (_, rep) = condition_record("?###???????? 3,2,1").unwrap();
        assert_eq!(rep.permutation_count(), 10);
        assert_eq!(rep.unfold().permutation_count(), 506250);
    }
}
