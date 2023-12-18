use std::{collections::HashMap, ops::Div};

use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::newline,
    combinator::{map, value},
    multi::{many0, separated_list0},
    IResult,
};

use crate::{Coord, ParseError, Translation};

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let pipes = parse(data)?;

    Ok(pipes
        .path_iter()
        .enumerate()
        .take_while(|(i, node)| {
            *i == 0 || node.coord != pipes.start_coord.expect("start coord not set")
        })
        .count()
        .div(2)
        .to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let pipes = parse(data)?;

    // https://en.wikipedia.org/wiki/Shoelace_formula
    let mut shoelace = pipes.path_iter().collect::<Vec<PipeNode>>();
    shoelace.push(shoelace[0]);
    let a = shoelace
        .windows(2)
        .map(|nodes| (nodes[0].coord.x * nodes[1].coord.y) - (nodes[0].coord.y * nodes[1].coord.x))
        .sum::<i64>()
        .div(2)
        .abs();

    // https://en.wikipedia.org/wiki/Pick%27s_theorem
    let b = shoelace.len() as i64 - 1;
    let i = a - b / 2 + 1;
    Ok(i.to_string())
}

struct Pipes {
    pipe_nodes: HashMap<Coord, PipeNode>,
    start_coord: Option<Coord>,
}

impl<'a> Pipes {
    fn new() -> Self {
        Self {
            pipe_nodes: HashMap::new(),
            start_coord: None,
        }
    }

    fn start_node(&self) -> PipeNode {
        self.get(self.start_coord.expect("start coord wasn't set"))
            .expect("start node not found")
    }

    fn set(&mut self, pipe_node: PipeNode) {
        if pipe_node.pipe_type == PipeType::Start {
            self.start_coord = Some(pipe_node.coord);
        }
        self.pipe_nodes.insert(pipe_node.coord, pipe_node);
    }

    fn get(&self, coord: Coord) -> Option<PipeNode> {
        self.pipe_nodes.get(&coord).copied()
    }

    fn path_iter(&'a self) -> impl Iterator<Item = PipeNode> + 'a {
        PipeIterator::new(self)
    }
}

#[derive(PartialEq, Copy, Clone, Debug)]
struct PipeNode {
    coord: Coord,
    pipe_type: PipeType,
}

impl PipeNode {
    fn new(coord: Coord, pipe_type: PipeType) -> Self {
        Self { coord, pipe_type }
    }

    fn connections(&self) -> Vec<Coord> {
        match self.pipe_type.connections() {
            Some((t1, t2)) => {
                vec![t1.translate(self.coord), t2.translate(self.coord)]
            }
            None => vec![],
        }
    }

    fn is_connection(&self, other: Coord) -> bool {
        if let Some((t1, t2)) = self.pipe_type.connections() {
            other == t1.translate(self.coord) || other == t2.translate(self.coord)
        } else {
            false
        }
    }
}

struct PipeIterator<'a> {
    pipes: &'a Pipes,
    current_coord: Option<Coord>,
    prev_coord: Option<Coord>,
}

impl<'a> PipeIterator<'a> {
    fn new(pipes: &'a Pipes) -> Self {
        Self {
            pipes,
            current_coord: None,
            prev_coord: None,
        }
    }
}

impl<'a> Iterator for PipeIterator<'a> {
    type Item = PipeNode;

    fn next(&mut self) -> Option<Self::Item> {
        match (self.current_coord, self.prev_coord) {
            (None, None) => {
                // we are at start
                let start = self.pipes.start_node();
                self.current_coord = Some(start.coord);
                Some(start)
            }
            (Some(start), None) => {
                // moving on from start to start + 1
                match start.neighbours().iter().find_map(|c| {
                    // don't care which of two nodes we follow. Go with first found
                    let node = self.pipes.get(*c)?;
                    if node.is_connection(start) {
                        Some(node)
                    } else {
                        None
                    }
                }) {
                    None => None,
                    Some(next) => {
                        self.prev_coord = Some(start);
                        self.current_coord = Some(next.coord);
                        Some(next)
                    }
                }
            }
            (Some(current), Some(prev)) => {
                let current_node = self.pipes.get(current).expect("node not found");
                match current_node.connections().iter().find_map(|c| {
                    if *c == prev {
                        None
                    } else {
                        let node = self.pipes.get(*c)?;
                        if node.is_connection(current) {
                            Some(node)
                        } else {
                            None
                        }
                    }
                }) {
                    None => None,
                    Some(next) => {
                        self.prev_coord = Some(current);
                        self.current_coord = Some(next.coord);
                        Some(next)
                    }
                }
            }
            _ => panic!("illegal state"),
        }
    }
}

#[derive(PartialEq, Clone, Copy, Debug)]
enum PipeType {
    Start,
    Vertical,
    Horizontal,
    NorthEastBend,
    NorthWestBend,
    SouthWestBend,
    SouthEastBend,
    Empty,
}

use Translation::*;

impl PipeType {
    fn connections(&self) -> Option<(Translation, Translation)> {
        match self {
            PipeType::Start => None,
            PipeType::Vertical => Some((North, South)),
            PipeType::Horizontal => Some((West, East)),
            PipeType::NorthEastBend => Some((North, East)),
            PipeType::NorthWestBend => Some((North, West)),
            PipeType::SouthWestBend => Some((South, West)),
            PipeType::SouthEastBend => Some((South, East)),
            PipeType::Empty => None,
        }
    }
}

fn parse(s: &str) -> Result<Pipes, ParseError> {
    let (rest, result) = pipes(s).map_err(|e| ParseError(e.to_string()))?;
    debug_assert_eq!(rest.trim(), "");

    Ok(result)
}

fn pipes(s: &str) -> IResult<&str, Pipes> {
    map(pipe_types_lines, |parts_lines| {
        let mut pipes = Pipes::new();
        for (y, parts_line) in parts_lines.into_iter().enumerate() {
            for (x, pipe_type) in parts_line.into_iter().enumerate() {
                match pipe_type {
                    PipeType::Empty => continue,
                    _ => {
                        let coord = Coord::new(x as i64, y as i64);
                        pipes.set(PipeNode::new(coord, pipe_type))
                    }
                }
            }
        }
        pipes
    })(s)
}

fn pipe_types_lines(s: &str) -> IResult<&str, Vec<Vec<PipeType>>> {
    separated_list0(newline, pipe_types_line)(s)
}

fn pipe_types_line(s: &str) -> IResult<&str, Vec<PipeType>> {
    many0(pipe_type)(s)
}

fn pipe_type(s: &str) -> IResult<&str, PipeType> {
    alt((
        value(PipeType::Start, tag("S")),
        value(PipeType::Vertical, tag("|")),
        value(PipeType::Horizontal, tag("-")),
        value(PipeType::NorthEastBend, tag("L")),
        value(PipeType::NorthWestBend, tag("J")),
        value(PipeType::SouthWestBend, tag("7")),
        value(PipeType::SouthEastBend, tag("F")),
        value(PipeType::Empty, tag(".")),
    ))(s)
}
