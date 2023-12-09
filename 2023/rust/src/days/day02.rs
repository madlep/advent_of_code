use crate::ParseError;

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
            .fold(Handful::default(), |acc, handful| acc.expand(handful))
    }
}

type ColorCount = u32;

use Color::*;
#[derive(Debug, PartialEq)]
enum Color {
    Red(ColorCount),
    Green(ColorCount),
    Blue(ColorCount),
}

#[derive(Debug, PartialEq, Default)]
struct Handful {
    r: ColorCount,
    g: ColorCount,
    b: ColorCount,
}

impl Handful {
    fn new(r: ColorCount, g: ColorCount, b: ColorCount) -> Self {
        Handful { r, g, b }
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

#[derive(Default)]
struct HandfulBuilder {
    r: Option<ColorCount>,
    g: Option<ColorCount>,
    b: Option<ColorCount>,
}

impl HandfulBuilder {
    fn color(self, col: Color) -> Result<Self, DuplicateColorError> {
        match col {
            Red(count) if self.r.is_none() => Ok(Self {
                r: Some(count),
                ..self
            }),
            Green(count) if self.g.is_none() => Ok(Self {
                g: Some(count),
                ..self
            }),

            Blue(count) if self.b.is_none() => Ok(Self {
                b: Some(count),
                ..self
            }),
            _ => Err(DuplicateColorError(col)),
        }
    }

    fn build(self) -> Handful {
        Handful::new(
            self.r.unwrap_or_default(),
            self.g.unwrap_or_default(),
            self.b.unwrap_or_default(),
        )
    }
}

fn parse(data: &str) -> Result<Vec<Game>, Box<dyn std::error::Error>> {
    //Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    //Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue";
    match separated_list0(tag("\n"), game)(data) {
        Ok((_rest, games)) => Ok(games),
        Err(e) => Err(ParseError(e.to_string()).into()),
    }
}

fn game(s: &str) -> IResult<&str, Game> {
    //Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    map(pair(game_id, handfuls), |(id, hfs)| Game {
        id,
        handfuls: hfs,
    })(s)
}

fn game_id(s: &str) -> IResult<&str, GameID> {
    //Game 1:
    delimited(tag("Game "), u32, tag(": "))(s)
}

fn handfuls(s: &str) -> IResult<&str, Vec<Handful>> {
    //3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    separated_list0(tag("; "), handful)(s)
}

fn handful(s: &str) -> IResult<&str, Handful> {
    //3 blue, 4 red
    map_res(handful_colors, |colors| {
        colors
            .into_iter()
            .try_fold(HandfulBuilder::default(), |builder, color| {
                builder.color(color)
            })
            .map(|builder| builder.build())
    })(s)
}

fn handful_colors(s: &str) -> IResult<&str, Vec<Color>> {
    //3 blue, 4 red
    separated_list0(tag(", "), handful_color)(s)
}

fn handful_color(s: &str) -> IResult<&str, Color> {
    //3 blue
    let r = map(terminated(u32, tag(" red")), Red);
    let g = map(terminated(u32, tag(" green")), Green);
    let b = map(terminated(u32, tag(" blue")), Blue);

    alt((r, g, b))(s)
}

#[derive(thiserror::Error, Debug, PartialEq)]
#[error("`setting {0:?} count more than once`")]
struct DuplicateColorError(Color);

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
        assert_eq!(handful_color("6 red"), Ok(("", Red(6))));
        assert_eq!(handful_color("3 blue"), Ok(("", Blue(3))));
        assert_eq!(handful_color("7 green"), Ok(("", Green(7))));
    }
}
