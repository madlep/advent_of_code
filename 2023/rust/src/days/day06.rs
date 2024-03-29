use crate::ParseError;
use std::{fmt::Debug, str::FromStr};

use nom::{
    bytes::complete::tag,
    character::complete::{multispace1, space1, u64 as nom_u64},
    multi::separated_list0,
    sequence::{preceded, separated_pair, terminated},
    IResult,
};

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let races = parse(data)?;

    Ok(races
        .iter()
        .map(|r| r.count_winning_options())
        .product::<usize>()
        .to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let race = parse2(data)?;

    Ok(race.count_winning_options().to_string())
}

struct Race {
    distance_record: Distance,
    time: Distance,
}

impl Race {
    fn count_winning_options(&self) -> usize {
        // this could be optimised, but runs fine ¯\_(ツ)_/¯
        (0..=self.time)
            .filter(|t| (self.time - t) * t > self.distance_record)
            .count()
    }
}

type Distance = u64;
type Time = u64;

fn parse(s: &str) -> Result<Vec<Race>, ParseError> {
    let (_rest, (times, distances)) = races(s).map_err(|e| ParseError(e.to_string()))?;
    Ok(distances
        .into_iter()
        .zip(times)
        .map(|(distance_record, time)| Race {
            distance_record,
            time,
        })
        .collect())
}

fn parse2(s: &str) -> Result<Race, ParseError> {
    let (_rest, (times, distances)) = races(s).map_err(|e| ParseError(e.to_string()))?;

    Ok(Race {
        distance_record: concat(distances),
        time: concat(times),
    })
}

fn concat<T>(vs: Vec<T>) -> T
where
    T: ToString + FromStr,
    <T as FromStr>::Err: Debug,
{
    vs.iter()
        .map(|d| d.to_string())
        .collect::<Vec<String>>()
        .join("")
        .parse::<T>()
        .unwrap()
}

fn races(s: &str) -> IResult<&str, (Vec<Time>, Vec<Distance>)> {
    separated_pair(times, multispace1, distances)(s)
}

fn times(s: &str) -> IResult<&str, Vec<Time>> {
    preceded(
        terminated(tag("Time:"), space1),
        separated_list0(space1, nom_u64),
    )(s)
}

fn distances(s: &str) -> IResult<&str, Vec<Distance>> {
    preceded(
        terminated(tag("Distance:"), space1),
        separated_list0(space1, nom_u64),
    )(s)
}
