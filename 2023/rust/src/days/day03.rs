use crate::Coord;
use std::collections::{HashMap, HashSet};

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    Ok(parse(data).part_numbers_iter().sum::<u32>().to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    Ok(parse(data)
        .gears_iter()
        .map(|g| g.ratio())
        .sum::<u32>()
        .to_string())
}

struct Schematic {
    numbers_list: Vec<Number>,
    numbers: SparseGrid<Number>,
    symbols: SparseGrid<Symbol>,
}

impl Schematic {
    fn new() -> Self {
        Self {
            numbers_list: Vec::new(),
            numbers: SparseGrid::new(),
            symbols: SparseGrid::new(),
        }
    }

    fn part_numbers_iter(&self) -> PartNumbersIter<impl Iterator<Item = &Number>> {
        PartNumbersIter {
            numbers_iter: self.numbers_list.iter(),
            symbols: &self.symbols,
        }
    }

    fn gears_iter(&self) -> GearsIter<impl Iterator<Item = &Symbol>> {
        GearsIter {
            symbols_iter: self.symbols.values(),
            numbers: &self.numbers,
        }
    }
}

type PartNumber = u32;

struct PartNumbersIter<'a, I> {
    numbers_iter: I,
    symbols: &'a SparseGrid<Symbol>,
}

impl<'a, I> Iterator for PartNumbersIter<'a, I>
where
    I: Iterator<Item = &'a Number>,
{
    type Item = PartNumber;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            let schematic_number = self.numbers_iter.next()?;
            if schematic_number
                .surrounding()
                .iter()
                .any(|coord| self.symbols.is_present(coord))
            {
                return Some(schematic_number.num);
            }
        }
    }
}

type Ratio = u32;

struct Gear<'a> {
    n1: &'a Number,
    n2: &'a Number,
}

impl<'a> Gear<'a> {
    fn ratio(&self) -> Ratio {
        self.n1.num * self.n2.num
    }
}

struct GearsIter<'a, I> {
    symbols_iter: I,
    numbers: &'a SparseGrid<Number>,
}

impl<'a, I> Iterator for GearsIter<'a, I>
where
    I: Iterator<Item = &'a Symbol>,
{
    type Item = Gear<'a>;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            let symbol = self.symbols_iter.next()?;
            if symbol.is_gear() {
                let nums = symbol
                    .surrounding()
                    .iter()
                    .filter_map(|coord| self.numbers.get(coord))
                    .collect::<HashSet<&Number>>();

                if nums.len() == 2 {
                    let n1 = nums.iter().nth(0).unwrap();
                    let n2 = nums.iter().nth(1).unwrap();
                    return Some(Gear { n1, n2 });
                }
            }
        }
    }
}

struct Symbol {
    sym: char,
    coord: Coord,
}

impl Symbol {
    fn is_gear(&self) -> bool {
        self.sym == '*'
    }

    fn surrounding(&self) -> Vec<Coord> {
        let mut result = Vec::new();
        for dx in [-1, 0, 1] {
            for dy in [-1, 0, 1] {
                if dx == 0 && dy == 0 {
                    continue;
                }
                result.push(self.coord.translate(dx, dy));
            }
        }
        result
    }
}

#[derive(PartialEq, Eq, Hash, Clone)]
struct Number {
    num: u32,
    coord: Coord,
    width: u32,
}

impl Number {
    fn surrounding(&self) -> Vec<Coord> {
        let c = &self.coord;
        let mut result = Vec::new();
        // row above + below
        for dx in -1..=(self.width as i64) {
            result.push(c.translate(dx, -1));
            result.push(c.translate(dx, 1));
        }
        // left end
        result.push(c.translate(-1, 0));
        // right end
        result.push(c.translate(self.width as i64, 0));

        result
    }

    fn coords(&self) -> Vec<Coord> {
        (0..(self.width as isize))
            .map(|dx| self.coord.translate(dx as i64, 0))
            .collect()
    }
}

struct SparseGrid<T> {
    cells: HashMap<Coord, T>,
}

impl<T> SparseGrid<T> {
    fn new() -> Self {
        SparseGrid {
            cells: HashMap::new(),
        }
    }

    fn is_present(&self, coord: &Coord) -> bool {
        self.cells.contains_key(coord)
    }

    fn get(&self, coord: &Coord) -> Option<&T> {
        self.cells.get(coord)
    }

    fn set(&mut self, coord: Coord, value: T) {
        self.cells.insert(coord, value);
    }

    fn values(&self) -> impl Iterator<Item = &T> {
        self.cells.values()
    }
}

enum Token {
    Number { n: u32, i: u32, width: u32 },
    Symbol { sym: char, i: u32 },
    Empty,
}

struct Tokenizer<'a> {
    line: &'a str,
    i: usize,
}

impl<'a> Tokenizer<'a> {
    fn new(line: &'a str) -> Self {
        Self { line, i: 0 }
    }
}

impl<'a> Iterator for Tokenizer<'a> {
    type Item = Token;

    fn next(&mut self) -> Option<Self::Item> {
        if self.i < self.line.len() {
            let s = &self.line[self.i..];
            let old_i = self.i as u32;
            if let Some((n, width)) = tokenize_number(s) {
                self.i += width;
                Some(Token::Number {
                    n,
                    i: old_i,
                    width: (width as u32),
                })
            } else if let Some(sym) = tokenize_symbol(s) {
                self.i += 1;
                Some(Token::Symbol { sym, i: old_i })
            } else {
                self.i += 1;
                Some(Token::Empty)
            }
        } else {
            None
        }
    }
}

fn tokenize_number(s: &str) -> Option<(u32, usize)> {
    let digits = s
        .chars()
        .take_while(|c| c.is_ascii_digit())
        .collect::<String>();

    let width = digits.len();

    let n = digits.parse::<u32>().ok()?;
    Some((n, width))
}

fn tokenize_symbol(s: &str) -> Option<char> {
    if s.starts_with(|c| {
        [
            '~', '`', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[',
            '{', ']', '}', '\\', '|', ';', ':', '\'', '"', ',', '<', '>', '/', '?',
        ]
        .contains(&c)
    }) {
        Some(s.chars().next().unwrap())
    } else {
        None
    }
}

fn parse(s: &str) -> Schematic {
    s.lines()
        .enumerate()
        .fold(Schematic::new(), |acc, (y, line)| {
            Tokenizer::new(line).fold(acc, |mut acc2, tok| match tok {
                Token::Number { n, i, width } => {
                    let x = i as i64;
                    let schematic_number = Number {
                        num: n,
                        coord: Coord::new(x, y as i64),
                        width,
                    };
                    for c in schematic_number.coords() {
                        acc2.numbers.set(c, schematic_number.clone());
                    }
                    acc2.numbers_list.push(schematic_number);
                    acc2
                }
                Token::Symbol { sym, i } => {
                    let x = i as i64;
                    let coord = Coord::new(x, y as i64);
                    acc2.symbols.set(coord.clone(), Symbol { sym, coord });
                    acc2
                }
                Token::Empty => acc2,
            })
        })
}
