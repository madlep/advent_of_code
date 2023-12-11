use nom::{
    character::complete::{i32 as nom_i32, newline, space1},
    combinator::map,
    multi::separated_list1,
    IResult,
};

use crate::ParseError;

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let sequences = parse(data)?;
    Ok(sequences
        .iter()
        .map(|seq| seq.extrapolate_next())
        .sum::<i32>()
        .to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let sequences = parse(data)?;
    Ok(sequences
        .iter()
        .map(|seq| seq.extrapolate_prev())
        .sum::<i32>()
        .to_string())
}

type Reading = i32;

#[derive(Debug)]
struct Sequence {
    readings: Vec<Reading>,
}

impl Sequence {
    fn new(readings: Vec<Reading>) -> Self {
        Self { readings }
    }

    fn extrapolate_next(&self) -> Reading {
        let ds = self.diffs();
        if ds.zeroes() {
            *self.readings.last().unwrap()
        } else {
            self.readings.last().unwrap() + ds.extrapolate_next()
        }
    }

    fn extrapolate_prev(&self) -> Reading {
        let ds = self.diffs();
        if ds.zeroes() {
            *self.readings.first().unwrap()
        } else {
            self.readings.first().unwrap() - ds.extrapolate_prev()
        }
    }

    fn diffs(&self) -> Self {
        Self::new(self.readings.windows(2).map(|rs| rs[1] - rs[0]).collect())
    }

    fn zeroes(&self) -> bool {
        self.readings.iter().all(|r| *r == 0)
    }
}

fn parse(s: &str) -> Result<Vec<Sequence>, ParseError> {
    let (rest, sequences) = sequences(s).map_err(|e| ParseError(e.to_string()))?;
    debug_assert_eq!(rest.trim(), "");

    Ok(sequences)
}

fn sequences(s: &str) -> IResult<&str, Vec<Sequence>> {
    separated_list1(newline, sequence)(s)
}

fn sequence(s: &str) -> IResult<&str, Sequence> {
    map(separated_list1(space1, reading), |readings| {
        Sequence::new(readings)
    })(s)
}

fn reading(s: &str) -> IResult<&str, Reading> {
    nom_i32(s)
}
