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
    numbers_list: Vec<SchematicNumber>,
    numbers: SparseGrid<SchematicNumber>,
    symbols: SparseGrid<SchematicSymbol>,
}

impl<'a> Schematic {
    fn new() -> Self {
        Self {
            numbers_list: Vec::new(),
            numbers: SparseGrid::new(),
            symbols: SparseGrid::new(),
        }
    }

    fn part_numbers_iter(&'a self) -> PartNumberIter<'a> {
        PartNumberIter {
            numbers_iter: self.numbers_list.iter(),
            symbols: &self.symbols,
        }
    }

    fn gears_iter(&'a self) -> GearsIter<'a> {
        GearsIter {
            symbols_iter: self.symbols.cells.values(),
            numbers: &self.numbers,
        }
    }
}

type PartNumber = u32;

struct PartNumberIter<'a> {
    numbers_iter: core::slice::Iter<'a, SchematicNumber>,
    symbols: &'a SparseGrid<SchematicSymbol>,
}

impl<'a> Iterator for PartNumberIter<'a> {
    type Item = PartNumber;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            let schematic_number = self.numbers_iter.next()?;
            if schematic_number
                .surrounding()
                .iter()
                .any(|coord| self.symbols.is_present(&coord))
            {
                return Some(schematic_number.num);
            }
        }
    }
}

type Ratio = u32;

struct Gear<'a> {
    n1: &'a SchematicNumber,
    n2: &'a SchematicNumber,
}

impl<'a> Gear<'a> {
    fn ratio(&self) -> Ratio {
        self.n1.num * self.n2.num
    }
}

struct GearsIter<'a> {
    symbols_iter: std::collections::hash_map::Values<'a, Coord, SchematicSymbol>,

    numbers: &'a SparseGrid<SchematicNumber>,
}

impl<'a> Iterator for GearsIter<'a> {
    type Item = Gear<'a>;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            let symbol = self.symbols_iter.next()?;
            if symbol.is_gear() {
                let nums = symbol
                    .surrounding()
                    .iter()
                    .filter_map(|coord| self.numbers.get(coord))
                    .collect::<HashSet<&SchematicNumber>>();

                if nums.len() == 2 {
                    let n1 = nums.iter().nth(0).unwrap();
                    let n2 = nums.iter().nth(1).unwrap();
                    return Some(Gear { n1, n2 });
                }
            }
        }
    }
}

#[derive(Hash, Eq, PartialEq, Clone)]
struct Coord {
    x: isize,
    y: isize,
}

impl Coord {
    fn new(x: isize, y: isize) -> Self {
        Coord { x, y }
    }

    fn translate(&self, x: isize, y: isize) -> Self {
        Self {
            x: self.x + x,
            y: self.y + y,
        }
    }
}

struct SchematicSymbol {
    sym: char,
    coord: Coord,
}

impl SchematicSymbol {
    fn is_gear(&self) -> bool {
        self.sym == '*'
    }

    fn surrounding(&self) -> Vec<Coord> {
        let mut result = Vec::new();
        for x in [-1, 0, 1] {
            for y in [-1, 0, 1] {
                if x == 0 && y == 0 {
                    continue;
                }
                result.push(self.coord.translate(x, y));
            }
        }
        result
    }
}

#[derive(PartialEq, Eq, Hash, Clone)]
struct SchematicNumber {
    num: u32,
    coord: Coord,
    width: u32,
}

impl SchematicNumber {
    fn surrounding(&self) -> Vec<Coord> {
        let c = &self.coord;
        let mut result = Vec::new();
        // row above + below
        for translate_x in -1..=(self.width as isize) {
            result.push(c.translate(translate_x, -1));
            result.push(c.translate(translate_x, 1));
        }
        // left end
        result.push(c.translate(-1, 0));
        // right end
        result.push(c.translate(self.width as isize, 0));

        result
    }

    fn coords(&self) -> Vec<Coord> {
        (0..(self.width as isize))
            .map(|translate_x| self.coord.translate(translate_x as isize, 0))
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
}

enum SchematicToken {
    Number { n: u32, i: usize, width: u32 },
    Symbol { sym: char, i: usize },
    Empty,
}

struct SchematicLineTokenizer<'a> {
    line: &'a str,
    i: usize,
}

impl<'a> SchematicLineTokenizer<'a> {
    fn new(line: &'a str) -> Self {
        Self { line, i: 0 }
    }
}

impl<'a> Iterator for SchematicLineTokenizer<'a> {
    type Item = SchematicToken;

    fn next(&mut self) -> Option<Self::Item> {
        if self.i < self.line.len() {
            let s = &self.line[self.i..];
            let old_i = self.i;
            if let Some((n, width)) = tokenize_number(s) {
                self.i += width;
                Some(SchematicToken::Number {
                    n,
                    i: old_i,
                    width: (width as u32),
                })
            } else if let Some(sym) = tokenize_symbol(s) {
                self.i += 1;
                Some(SchematicToken::Symbol { sym, i: old_i })
            } else {
                self.i += 1;
                Some(SchematicToken::Empty)
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
        Some(s.chars().nth(0).unwrap())
    } else {
        None
    }
}

fn parse(s: &str) -> Schematic {
    s.lines()
        .enumerate()
        .fold(Schematic::new(), |acc, (y, line)| {
            SchematicLineTokenizer::new(&line).fold(acc, |mut acc2, tok| match tok {
                SchematicToken::Number { n, i, width } => {
                    let x = i;
                    let schematic_number = SchematicNumber {
                        num: n,
                        coord: Coord::new(x as isize, y as isize),
                        width,
                    };
                    for c in schematic_number.coords() {
                        acc2.numbers.set(c, schematic_number.clone());
                    }
                    acc2.numbers_list.push(schematic_number);
                    acc2
                }
                SchematicToken::Symbol { sym, i } => {
                    let x = i;
                    let coord = Coord::new(x as isize, y as isize);
                    acc2.symbols
                        .set(coord.clone(), SchematicSymbol { sym, coord });
                    acc2
                }
                SchematicToken::Empty => acc2,
            })
        })
}
