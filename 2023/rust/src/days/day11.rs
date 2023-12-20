use std::{cmp::max, collections::HashSet};

use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::newline,
    combinator::value,
    multi::{many0, separated_list0},
    IResult,
};

use crate::{Coord, ParseError};

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let space_map = parse(data)?;

    let expanded_rows = space_map.expanded_rows();
    let expanded_columns = space_map.expanded_columns();

    let mut galaxies = space_map.galaxies();
    galaxies.sort_by_key(|g| (g.y, g.x));

    let mut total_lengths = 0;
    for g1_id in 0..galaxies.len() {
        for g2_id in g1_id + 1..galaxies.len() {
            let g1 = galaxies[g1_id];
            let g2 = galaxies[g2_id];
            let d = distance(g1, g2, &expanded_rows, &expanded_columns);
            total_lengths += d;
        }
    }

    Ok(total_lengths.to_string())
}

pub fn part2(_data: &str) -> Result<String, Box<dyn std::error::Error>> {
    todo!()
}

fn distance(g1: Coord, g2: Coord, expanded_rows: &Vec<i64>, expanded_columns: &Vec<i64>) -> i64 {
    let (x1, x2) = {
        let mut xs = [g1.x, g2.x];
        xs.sort();
        (xs[0], xs[1])
    };

    let (y1, y2) = {
        let mut ys = [g1.y, g2.y];
        ys.sort();
        (ys[0], ys[1])
    };

    let x_expanded = calc_expansion(x1, x2, &expanded_columns);
    let y_expanded = calc_expansion(y1, y2, &expanded_rows);

    (x_expanded + y_expanded).abs()
}

fn calc_expansion(from: i64, to: i64, expanded: &Vec<i64>) -> i64 {
    let exp_start = expanded.partition_point(|i| *i < from) as i64 + 1;
    let exp_end = expanded.partition_point(|i| *i < to) as i64;

    let unexpanded_size = to - from;
    if exp_end >= exp_start {
        unexpanded_size + exp_end - exp_start + 1
    } else {
        unexpanded_size
    }
}

struct SpaceMap {
    galaxy_coords: HashSet<Coord>,
    width: i64,
    height: i64,
}
impl SpaceMap {
    fn new() -> Self {
        SpaceMap {
            galaxy_coords: HashSet::new(),
            width: 0,
            height: 0,
        }
    }

    fn set(&mut self, coord: Coord) {
        self.width = max(self.width, coord.x + 1);
        self.height = max(self.height, coord.y + 1);
        self.galaxy_coords.insert(coord);
    }

    fn expanded_rows(&self) -> Vec<i64> {
        let mut row_set = HashSet::new();
        for i in 0..self.height {
            row_set.insert(i);
        }

        for g in self.galaxy_coords.iter() {
            row_set.remove(&g.y);
        }

        let mut rows = row_set.iter().cloned().collect::<Vec<i64>>();
        rows.sort();
        rows
    }

    fn expanded_columns(&self) -> Vec<i64> {
        let mut col_set = HashSet::new();
        for i in 0..self.width {
            col_set.insert(i);
        }

        for g in self.galaxy_coords.iter() {
            col_set.remove(&g.x);
        }

        let mut cols = col_set.iter().cloned().collect::<Vec<i64>>();
        cols.sort();
        cols
    }

    fn galaxies(&self) -> Vec<Coord> {
        self.galaxy_coords.iter().cloned().collect::<Vec<Coord>>()
    }
}

#[derive(PartialEq, Eq, Copy, Clone)]
enum MapElement {
    Galaxy,
    Empty,
}

fn parse(s: &str) -> Result<SpaceMap, ParseError> {
    let (rest, data) = map_data(s).map_err(|e| ParseError(e.to_string()))?;
    debug_assert_eq!(rest.trim(), "");

    let mut space_map = SpaceMap::new();
    for (y, data_line) in data.iter().enumerate() {
        for (x, datum) in data_line.iter().enumerate() {
            if *datum == MapElement::Galaxy {
                space_map.set(Coord::new(x as i64, y as i64));
            }
        }
    }

    Ok(space_map)
}

fn map_data(s: &str) -> IResult<&str, Vec<Vec<MapElement>>> {
    separated_list0(newline, map_line)(s)
}

fn map_line(s: &str) -> IResult<&str, Vec<MapElement>> {
    many0(map_element)(s)
}

fn map_element(s: &str) -> IResult<&str, MapElement> {
    alt((
        value(MapElement::Galaxy, tag("#")),
        value(MapElement::Empty, tag(".")),
    ))(s)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_distance() {
        assert_eq!(
            distance(
                Coord::new(1, 5),
                Coord::new(4, 9),
                &vec![3, 7],
                &vec![2, 5, 8]
            ),
            9
        );
    }
}
