use std::{
    cmp::{self, Ordering},
    collections::HashMap,
    iter::Peekable,
    ops::Range,
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

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let (seeds, almanac) = parse(data)?;

    let seed_ranges = seeds
        .chunks(2)
        .map(|start_end| start_end[0]..start_end[0] + start_end[1])
        .collect::<Vec<Range<Id>>>();

    Ok(almanac
        .location_ranges_for_seed_range(seed_ranges)
        .min_by_key(|r| r.start)
        .unwrap()
        .start
        .to_string())
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

impl<'a> Almanac {
    fn new() -> Self {
        Almanac {
            category_mappings: HashMap::new(),
        }
    }

    fn location_for_seed(&self, seed: Id) -> Id {
        Category::lookup_iter().fold(seed, |id, lookup| self.category_mappings[&lookup].map(id))
    }

    fn location_ranges_for_seed_range(
        &self,
        seed_ranges: Vec<Range<Id>>,
    ) -> Box<dyn Iterator<Item = Range<Id>> + '_> {
        Category::lookup_iter().fold(Box::new(seed_ranges.into_iter()), |ranges, lookup| {
            Box::new(ranges.flat_map(move |range| self.category_mappings[&lookup].map_range(range)))
        })
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

impl<'a> CategoryMapping {
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

    fn map_range(&'a self, from: Range<Id>) -> impl Iterator<Item = Range<Id>> + 'a {
        MapRangeIterator::new(from, self.mappings.iter().cloned())
    }
}

struct MapRangeIterator<I>
where
    I: Iterator<Item = Mapping>,
{
    remaining: Option<Range<Id>>,
    mappings_iter: Peekable<I>,
}

impl<I> MapRangeIterator<I>
where
    I: Iterator<Item = Mapping>,
{
    fn new(from: Range<Id>, mappings_iter: I) -> Self {
        MapRangeIterator {
            remaining: Some(from),
            mappings_iter: mappings_iter.peekable(),
        }
    }
}

impl<I> Iterator for MapRangeIterator<I>
where
    I: Iterator<Item = Mapping>,
{
    type Item = Range<Id>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.remaining.is_none() {
            return None;
        }

        let r = self.remaining.as_ref().map(|r| r.clone()).unwrap();
        let rstart = r.start;
        let rend = r.end;

        while let Some(peeked) = self.mappings_iter.peek() {
            if peeked.range.end <= rstart {
                self.mappings_iter.next();
            } else {
                break;
            }
        }

        let peeked = self.mappings_iter.peek();
        if peeked.is_none() {
            // no mappings left, return range unchanged and terminate
            return self.remaining.take();
        }

        let m = peeked.map(|m| m.clone()).unwrap();
        let mstart = m.range.start;
        let mend = m.range.end;

        if rend <= mstart {
            // we're before the first mapping, return range unchanged and terminate
            self.remaining.take()
        } else if rstart < mstart && rend > mstart {
            // start of range isn't in a mapping, split the range, return the first
            // part unmapped, then set up remaining as other part to be handled
            // next time
            self.remaining.replace(mstart..rend);
            Some(rstart..mstart)
        } else if rstart >= mstart && rend <= mend {
            // range is totally contained by mapping, map it and return it and
            // terminate
            self.remaining = None;
            Some(m.map_range(rstart..rend))
        } else if rstart >= mstart && rend > mend {
            // start of range is in mapping, last part isn't. split the range, map
            // the first part and return it, then set second part to be remaining,
            // and bump the mapping iterator
            self.mappings_iter.next();
            self.remaining = Some(mend..rend);
            Some(m.map_range(rstart..mend))
        } else {
            panic!("rem:{:?} peeked:{:?}", r, m.range);
        }
    }
}

#[derive(PartialEq, Eq, Clone, Debug)]
struct Mapping {
    range: Range<Id>,
    offset: i64,
}

impl Mapping {
    fn new(source: u64, destination: u64, range_size: u64) -> Self {
        Self {
            range: source..source + range_size,
            offset: (destination as i64) - (source as i64),
        }
    }
    fn can_handle(&self, id: Id) -> Ordering {
        if id < self.range.start {
            Ordering::Greater
        } else if self.range.contains(&id) {
            Ordering::Equal
        } else {
            Ordering::Less
        }
    }

    fn map(&self, id: Id) -> Id {
        (id as i64 + self.offset) as Id
    }

    fn map_range(&self, id_range: Range<Id>) -> Range<Id> {
        self.map(id_range.start)..self.map(id_range.end)
    }
}

impl PartialOrd for Mapping {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Mapping {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.range.start.cmp(&other.range.start)
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
        |(destination, source, range)| Mapping::new(source, destination, range),
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
                    mappings: vec![Mapping::new(50, 52, 48), Mapping::new(98, 50, 2),]
                }
            ))
        )
    }

    #[test]
    fn category_mapping_map() {
        let cm = CategoryMapping {
            source: Seed,
            destination: Soil,
            mappings: vec![Mapping::new(50, 52, 48), Mapping::new(98, 50, 2)],
        };

        assert_eq!(cm.map(79), 81);
    }
}
