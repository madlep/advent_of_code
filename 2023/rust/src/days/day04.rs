use std::collections::HashMap;

use nom::{
    bytes::complete::tag,
    character::complete::{self, newline, space1},
    combinator::map,
    multi::separated_list0,
    sequence::{delimited, pair, separated_pair, tuple},
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
        .map(|c| c.total_for_card(&mut HashMap::new(), &cards))
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
        let mut winning_sorted = self.winning.clone();
        winning_sorted.sort();
        let mut ours_sorted = self.ours.clone();
        ours_sorted.sort();
        let mut winning_it = winning_sorted.iter();
        let mut ours_it = ours_sorted.iter();

        let mut result = 0;
        let mut next_w = winning_it.next();
        let mut next_o = ours_it.next();
        loop {
            if let (Some(w), Some(o)) = (next_w, next_o) {
                if w > o {
                    next_o = ours_it.next();
                } else if w < o {
                    next_w = winning_it.next();
                } else {
                    result += 1;
                    next_w = winning_it.next();
                    next_o = ours_it.next();
                }
            } else {
                break;
            }
        }
        result
    }

    fn total_for_card(&self, memo: &mut HashMap<CardId, u32>, cards: &Vec<Card>) -> u32 {
        if let Some(total) = memo.get(&self.id) {
            *total
        } else {
            // add 1 for this card
            let card_total = 1
                + (1..=self.matching_ids_count())
                    .map(|offset_id| {
                        let other_card_id = self.id + offset_id;
                        let other_card = &cards[(other_card_id - 1) as usize];
                        other_card.total_for_card(memo, cards)
                    })
                    .sum::<u32>();
            memo.insert(self.id, card_total);
            card_total
        }
    }
}

fn parse(s: &str) -> Result<Vec<Card>, ParseError> {
    let (_rest, cs) = cards(s).map_err(|e| ParseError(e.to_string()))?;
    Ok(cs)
}

fn cards(s: &str) -> IResult<&str, Vec<Card>> {
    separated_list0(newline, card)(s)
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

#[derive(thiserror::Error, Debug, PartialEq)]
#[error("error parsing: `{0}`")]
struct ParseError(String);

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
