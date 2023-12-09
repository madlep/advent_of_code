use crate::ParseError;

use std::collections::{HashMap, HashSet};

use nom::{
    bytes::complete::tag,
    character::complete::{self, newline, space1},
    combinator::{eof, map},
    multi::separated_list0,
    sequence::{delimited, pair, separated_pair, terminated, tuple},
    IResult,
};

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let cards = parse(data)?;
    Ok(cards.iter().map(|c| c.points()).sum::<u32>().to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let cards = parse(data)?;
    Ok(cards
        .iter()
        .map(|c| c.total_cards(&mut HashMap::new(), &cards))
        .sum::<u32>()
        .to_string())
}

type Point = u32;
type CardId = u32;

#[derive(Debug, PartialEq)]
struct Card {
    id: CardId,
    winning: Vec<Point>,
    ours: Vec<Point>,
}

impl Card {
    fn points(&self) -> Point {
        let result = self.matching_ids_count();
        if result > 0 {
            2_u32.pow(result - 1)
        } else {
            0
        }
    }

    fn matching_ids_count(&self) -> u32 {
        let winning: HashSet<&u32> = HashSet::from_iter(&self.winning);
        let ours: HashSet<&u32> = HashSet::from_iter(&self.ours);
        winning.intersection(&ours).count() as u32
    }

    fn total_cards(&self, memo: &mut HashMap<CardId, u32>, cards: &Vec<Card>) -> u32 {
        if let Some(total) = memo.get(&self.id) {
            *total
        } else {
            let cards_total = (1..=self.matching_ids_count())
                .map(|offset| cards[(self.id + offset - 1) as usize].total_cards(memo, cards))
                .sum::<u32>()
                + 1; // 1 for this card
            memo.insert(self.id, cards_total);
            cards_total
        }
    }
}

fn parse(s: &str) -> Result<Vec<Card>, ParseError> {
    let (_rest, cs) = cards(s).map_err(|e| ParseError(e.to_string()))?;
    Ok(cs)
}

fn cards(s: &str) -> IResult<&str, Vec<Card>> {
    terminated(separated_list0(newline, card), eof)(s)
}

// Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
fn card(s: &str) -> IResult<&str, Card> {
    map(pair(card_id, numbers), |(id, (winning, ours))| Card {
        id,
        winning,
        ours,
    })(s)
}

fn card_id(s: &str) -> IResult<&str, u32> {
    delimited(
        pair(tag("Card"), space1),
        complete::u32,
        pair(tag(":"), space1),
    )(s)
}

fn numbers(s: &str) -> IResult<&str, (Vec<Point>, Vec<Point>)> {
    separated_pair(number_list, tuple((space1, tag("|"), space1)), number_list)(s)
}

fn number_list(s: &str) -> IResult<&str, Vec<Point>> {
    separated_list0(space1, complete::u32)(s)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_card() {
        assert_eq!(
            card("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53").unwrap(),
            (
                "",
                Card {
                    id: 1,
                    winning: vec![41, 48, 83, 86, 17],
                    ours: vec![83, 86, 6, 31, 17, 9, 48, 53]
                }
            )
        );
    }
}
