use std::{collections::HashMap, ops::Div};

use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::newline,
    combinator::{map, value},
    multi::{many0, separated_list0},
    IResult,
};

use crate::{Coord, ParseError};

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let pipes = parse(data)?;

    let path_iter = pipes.path_iter();
    Ok(path_iter
        .enumerate()
        .take_while(|(i, node)| {
            *i == 0 || node.coord != pipes.start_coord.expect("start coord not set")
        })
        .count()
        .div(2)
        .to_string())
}

pub fn part2(_data: &str) -> Result<String, Box<dyn std::error::Error>> {
    todo!()
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
        if pipe_node.pipe_part == Start {
            self.start_coord = Some(pipe_node.coord);
        }
        self.pipe_nodes.insert(pipe_node.coord, pipe_node);
    }

    fn get(&self, coord: Coord) -> Option<PipeNode> {
        self.pipe_nodes.get(&coord).copied()
    }

    fn path_iter(&'a self) -> impl Iterator<Item = PipeNode> + 'a {
        PipeIterator::new(&self)
    }
}

#[derive(PartialEq, Copy, Clone)]
struct PipeNode {
    coord: Coord,
    pipe_part: PipePart,
}

impl PipeNode {
    fn new(coord: Coord, pipe_part: PipePart) -> Self {
        Self { coord, pipe_part }
    }

    fn connections(&self) -> Vec<Coord> {
        match self.pipe_part.connections() {
            Some(((x1, y1), (x2, y2))) => {
                vec![self.coord.translate(x1, y1), self.coord.translate(x2, y2)]
            }
            None => vec![],
        }
    }

    fn is_connection(&self, other: Coord) -> bool {
        if let Some((c1, c2)) = self.pipe_part.connections() {
            other == self.coord.translate(c1.0, c1.1) || other == self.coord.translate(c2.0, c2.1)
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

#[derive(PartialEq, Clone, Copy)]
enum PipePart {
    Start,
    Vertical,
    Horizontal,
    NorthEastBend,
    NorthWestBend,
    SouthWestBend,
    SouthEastBend,
    Empty,
}
use PipePart::*;

const NORTH: (i64, i64) = (0, -1);
const EAST: (i64, i64) = (1, 0);
const SOUTH: (i64, i64) = (0, 1);
const WEST: (i64, i64) = (-1, 0);

impl PipePart {
    fn connections(&self) -> Option<((i64, i64), (i64, i64))> {
        match self {
            Start => None,
            Vertical => Some((NORTH, SOUTH)),
            Horizontal => Some((WEST, EAST)),
            NorthEastBend => Some((NORTH, EAST)),
            NorthWestBend => Some((NORTH, WEST)),
            SouthWestBend => Some((SOUTH, WEST)),
            SouthEastBend => Some((SOUTH, EAST)),
            Empty => None,
        }
    }
}

fn parse(s: &str) -> Result<Pipes, ParseError> {
    let (rest, result) = pipes(s).map_err(|e| ParseError(e.to_string()))?;
    debug_assert_eq!(rest.trim(), "");

    Ok(result)
}

fn pipes(s: &str) -> IResult<&str, Pipes> {
    map(pipe_parts_lines, |parts_lines| {
        let mut pipes = Pipes::new();
        for (y, parts_line) in parts_lines.into_iter().enumerate() {
            for (x, pipe_part) in parts_line.into_iter().enumerate() {
                match pipe_part {
                    Empty => continue,
                    _ => {
                        let coord = Coord::new(x as i64, y as i64);
                        pipes.set(PipeNode::new(coord, pipe_part))
                    }
                }
            }
        }
        pipes
    })(s)
}

fn pipe_parts_lines(s: &str) -> IResult<&str, Vec<Vec<PipePart>>> {
    separated_list0(newline, pipe_parts_line)(s)
}

fn pipe_parts_line(s: &str) -> IResult<&str, Vec<PipePart>> {
    many0(pipe_part)(s)
}

fn pipe_part(s: &str) -> IResult<&str, PipePart> {
    alt((
        value(Start, tag("S")),
        value(Vertical, tag("|")),
        value(Horizontal, tag("-")),
        value(NorthEastBend, tag("L")),
        value(NorthWestBend, tag("J")),
        value(SouthWestBend, tag("7")),
        value(SouthEastBend, tag("F")),
        value(Empty, tag(".")),
    ))(s)
}
