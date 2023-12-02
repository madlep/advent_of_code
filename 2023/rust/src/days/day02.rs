use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::u32,
    combinator::{map, map_res},
    multi::separated_list0,
    sequence::{delimited, pair, terminated},
    IResult,
};
use std::cmp;

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let red = 12;
    let green = 13;
    let blue = 14;
    let posibility = Handful::new(red, green, blue);

    let games = parse(data)?;
    Ok(games
        .iter()
        .filter(|game| game.possible(&posibility))
        .map(|game| game.id)
        .sum::<u32>()
        .to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let games = parse(data)?;
    Ok(games
        .iter()
        .map(|game| game.fewest_posibility().power())
        .sum::<u32>()
        .to_string())
}

type GameID = u32;

#[derive(Debug, PartialEq)]
struct Game {
    id: GameID,
    handfuls: Vec<Handful>,
}

impl Game {
    fn possible(&self, posibility: &Handful) -> bool {
        self.handfuls
            .iter()
            .all(|handful| handful.possible(posibility))
    }

    fn fewest_posibility(&self) -> Handful {
        self.handfuls
            .iter()
            .fold(Handful::empty(), |acc, handful| acc.expand(handful))
    }
}

type ColorCount = u32;

#[derive(Debug, PartialEq)]
enum Color {
    Red(ColorCount),
    Green(ColorCount),
    Blue(ColorCount),
}

impl Color {
    fn count(&self) -> ColorCount {
        match self {
            Color::Red(c) => *c,
            Color::Green(c) => *c,
            Color::Blue(c) => *c,
        }
    }
}

#[derive(Debug, PartialEq)]
struct Handful {
    r: ColorCount,
    g: ColorCount,
    b: ColorCount,
}

impl Handful {
    fn new(r: ColorCount, g: ColorCount, b: ColorCount) -> Self {
        Handful { r, g, b }
    }

    fn empty() -> Self {
        Self::new(0, 0, 0)
    }

    fn possible(&self, posibility: &Handful) -> bool {
        self.r <= posibility.r && self.g <= posibility.g && self.b <= posibility.b
    }

    fn expand(&self, other: &Handful) -> Self {
        Self::new(
            cmp::max(self.r, other.r),
            cmp::max(self.g, other.g),
            cmp::max(self.b, other.b),
        )
    }

    fn power(&self) -> u32 {
        self.r * self.g * self.b
    }
}

struct HandfulBuilder {
    r: Option<Color>,
    g: Option<Color>,
    b: Option<Color>,
}

impl HandfulBuilder {
    fn new() -> Self {
        HandfulBuilder {
            r: None,
            g: None,
            b: None,
        }
    }

    fn color(mut self, col: Color) -> Result<Self, ColorError> {
        match col {
            Color::Red(_) if self.r.is_none() => {
                self.r = Some(col);
                Ok(self)
            }
            Color::Green(_) if self.g.is_none() => {
                self.g = Some(col);
                Ok(self)
            }
            Color::Blue(_) if self.b.is_none() => {
                self.b = Some(col);
                Ok(self)
            }
            _ => Err(ColorError::DuplicateColorError(col)),
        }
    }

    fn to_handful(self) -> Handful {
        Handful::new(
            self.r.map_or(0, |c| c.count()),
            self.g.map_or(0, |c| c.count()),
            self.b.map_or(0, |c| c.count()),
        )
    }
}

#[derive(thiserror::Error, Debug, PartialEq)]
#[error("error parsing: `{0}`")]
struct ParseError(String);

#[derive(thiserror::Error, Debug, PartialEq)]
enum ColorError {
    #[error("`setting {0:?} count more than once`")]
    DuplicateColorError(Color),
}

fn parse(data: &str) -> Result<Vec<Game>, Box<dyn std::error::Error>> {
    match separated_list0(tag("\n"), game)(data) {
        Ok((_rest, games)) => Ok(games),
        Err(e) => Err(ParseError(e.to_string()).into()),
    }
}

fn game(s: &str) -> IResult<&str, Game> {
    map(pair(game_id, handfuls), |(id, hfs)| Game {
        id,
        handfuls: hfs,
    })(s)
}

fn game_id(s: &str) -> IResult<&str, GameID> {
    delimited(tag("Game "), u32, tag(": "))(s)
}

fn handfuls(s: &str) -> IResult<&str, Vec<Handful>> {
    separated_list0(tag("; "), handful)(s)
}

fn handful(s: &str) -> IResult<&str, Handful> {
    map_res(handful_colors, |colors| {
        colors
            .into_iter()
            .fold(Ok(HandfulBuilder::new()), |acc, color| {
                acc.and_then(|acc| acc.color(color))
            })
            .map(|b| b.to_handful())
    })(s)
}

fn handful_colors(s: &str) -> IResult<&str, Vec<Color>> {
    separated_list0(tag(", "), handful_color)(s)
}

fn handful_color(s: &str) -> IResult<&str, Color> {
    let r = map(terminated(u32, tag(" red")), |count| Color::Red(count));
    let g = map(terminated(u32, tag(" green")), |count| Color::Green(count));
    let b = map(terminated(u32, tag(" blue")), |count| Color::Blue(count));

    alt((r, g, b))(s)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_games() {
        let data = "\
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue";

        assert_eq!(
            parse(data).unwrap(),
            vec![
                Game {
                    id: 1,
                    handfuls: vec![
                        Handful::new(4, 0, 3),
                        Handful::new(1, 2, 6),
                        Handful::new(0, 2, 0),
                    ]
                },
                Game {
                    id: 2,
                    handfuls: vec![
                        Handful::new(0, 2, 1),
                        Handful::new(1, 3, 4),
                        Handful::new(0, 1, 1),
                    ]
                }
            ]
        );
    }

    #[test]
    fn parse_handful() {
        assert_eq!(handful("3 blue, 4 red"), Ok(("", Handful::new(4, 0, 3))));

        assert_eq!(
            handful("1 blue, 2 red, 3 green"),
            Ok(("", Handful::new(2, 3, 1)))
        );

        assert!(handful("1 blue, 2 red, 3 green, 3 red").is_err());
    }

    #[test]
    fn parse_handful_colors() {
        assert_eq!(handful_color("6 red"), Ok(("", Color::Red(6))));
        assert_eq!(handful_color("3 blue"), Ok(("", Color::Blue(3))));
        assert_eq!(handful_color("7 green"), Ok(("", Color::Green(7))));
    }
}
