use std::{
    cmp::{self, Ordering},
    collections::HashMap,
};

use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{newline, space0, space1, u64 as nom_u64},
    combinator::{map, value},
    multi::separated_list0,
    sequence::{pair, preceded, separated_pair, terminated, tuple},
    IResult,
};

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let (seeds, almanac) = parse(data)?;
    Ok(seeds
        .iter()
        .map(|s| almanac.location_for_seed(*s))
        .fold(Id::MAX, cmp::min)
        .to_string())
}

pub fn part2(_data: &str) -> Result<String, Box<dyn std::error::Error>> {
    todo!()
}

type Id = u64;

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug)]
enum Category {
    Seed,
    Soil,
    Fertilizer,
    Water,
    Light,
    Temperature,
    Humidity,
    Location,
}
impl Category {
    fn lookup_iter() -> impl Iterator<Item = (Category, Category)> {
        [
            Seed,
            Soil,
            Fertilizer,
            Water,
            Light,
            Temperature,
            Humidity,
            Location,
        ]
        .windows(2)
        .map(|cats| (cats[0], cats[1]))
    }
}
use Category::*;

#[derive(Debug)]
struct Almanac {
    category_mappings: HashMap<(Category, Category), CategoryMapping>,
}

impl Almanac {
    fn new() -> Self {
        Almanac {
            category_mappings: HashMap::new(),
        }
    }

    fn location_for_seed(&self, seed: Id) -> Id {
        Category::lookup_iter().fold(seed, |id, lookup| self.category_mappings[&lookup].map(id))
    }

    fn add_category_mapping(&mut self, cm: CategoryMapping) {
        self.category_mappings
            .insert((cm.source, cm.destination), cm);
    }
}

#[derive(Debug, PartialEq)]
struct CategoryMapping {
    source: Category,
    destination: Category,
    mappings: Vec<Mapping>,
}

impl CategoryMapping {
    fn new(source: Category, destination: Category, mappings: Vec<Mapping>) -> Self {
        let mut mappings = mappings.clone();
        mappings.sort();
        Self {
            source,
            destination,
            mappings,
        }
    }

    fn map(&self, from: Id) -> Id {
        match self.mappings.binary_search_by(|m| m.can_handle(from)) {
            Ok(idx) => self.mappings[idx].map(from),
            Err(_) => from,
        }
    }
}

#[derive(PartialEq, Eq, PartialOrd, Ord, Clone, Debug)]
struct Mapping {
    source: Id,
    destination: Id,
    range: u64,
}

impl Mapping {
    fn can_handle(&self, id: Id) -> Ordering {
        if id < self.source {
            Ordering::Greater
        } else if id >= self.source && id < self.source + self.range {
            Ordering::Equal
        } else {
            Ordering::Less
        }
    }

    fn map(&self, id: Id) -> Id {
        self.destination + id - self.source
    }
}

fn parse(s: &str) -> Result<(Vec<Id>, Almanac), ParseError> {
    let (_rest, (seeds, almanac)) = seeds_almanac(s).map_err(|e| ParseError(e.to_string()))?;
    Ok((seeds, almanac))
}

fn seeds_almanac(s: &str) -> IResult<&str, (Vec<Id>, Almanac)> {
    separated_pair(seeds, pair(newline, newline), almanac)(s)
}

fn seeds(s: &str) -> IResult<&str, Vec<Id>> {
    preceded(
        terminated(tag("seeds:"), space1),
        separated_list0(space1, seed),
    )(s)
}

fn seed(s: &str) -> IResult<&str, Id> {
    nom_u64(s)
}

fn almanac(s: &str) -> IResult<&str, Almanac> {
    map(
        separated_list0(pair(newline, newline), category_mapping),
        |mappings| {
            mappings
                .into_iter()
                .fold(Almanac::new(), |mut almanac, mapping| {
                    almanac.add_category_mapping(mapping);
                    almanac
                })
        },
    )(s)
}

fn category_mapping(s: &str) -> IResult<&str, CategoryMapping> {
    map(
        separated_pair(categories, newline, mappings),
        |((source, destination), mappings)| CategoryMapping::new(source, destination, mappings),
    )(s)
}

fn categories(s: &str) -> IResult<&str, (Category, Category)> {
    terminated(
        separated_pair(category, tag("-to-"), category),
        tag(" map:"),
    )(s)
}

fn category(s: &str) -> IResult<&str, Category> {
    alt((
        value(Seed, tag("seed")),
        value(Soil, tag("soil")),
        value(Fertilizer, tag("fertilizer")),
        value(Water, tag("water")),
        value(Light, tag("light")),
        value(Temperature, tag("temperature")),
        value(Humidity, tag("humidity")),
        value(Location, tag("location")),
    ))(s)
}

fn mappings(s: &str) -> IResult<&str, Vec<Mapping>> {
    separated_list0(newline, mapping)(s)
}

fn mapping(s: &str) -> IResult<&str, Mapping> {
    map(
        tuple((
            terminated(nom_u64, space1),
            terminated(nom_u64, space1),
            terminated(nom_u64, space0),
        )),
        |(destination, source, range)| Mapping {
            source,
            destination,
            range,
        },
    )(s)
}

#[derive(thiserror::Error, Debug, PartialEq)]
#[error("error parsing: `{0}`")]
struct ParseError(String);

#[cfg(test)]
mod tests {
    //use super::Category::*;
    use super::*;

    #[test]
    fn parse_categories() {
        let data = "seed-to-soil map:";
        assert_eq!(categories(data), Ok(("", (Seed, Soil))));
    }

    #[test]
    fn parse_category() {
        assert_eq!(category("seed"), Ok(("", Seed)));
        assert_eq!(category("soil"), Ok(("", Soil)));
        assert_eq!(category("fertilizer"), Ok(("", Fertilizer)));
        assert_eq!(category("water"), Ok(("", Water)));
        assert_eq!(category("light"), Ok(("", Light)));
        assert_eq!(category("humidity"), Ok(("", Humidity)));
        assert_eq!(category("location"), Ok(("", Location)));
    }

    #[test]
    fn parse_category_mapping() {
        let data = "\
seed-to-soil map:
50 98 2
52 50 48";
        assert_eq!(
            category_mapping(data),
            Ok((
                "",
                CategoryMapping {
                    source: Seed,
                    destination: Soil,
                    mappings: vec![
                        Mapping {
                            source: 50,
                            destination: 52,
                            range: 48
                        },
                        Mapping {
                            source: 98,
                            destination: 50,
                            range: 2
                        },
                    ]
                }
            ))
        )
    }

    #[test]
    fn category_mapping_map() {
        let cm = CategoryMapping {
            source: Seed,
            destination: Soil,
            mappings: vec![
                Mapping {
                    source: 50,
                    destination: 52,
                    range: 48,
                },
                Mapping {
                    source: 98,
                    destination: 50,
                    range: 2,
                },
            ],
        };

        assert_eq!(cm.map(79), 81);
    }
}
