use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{newline, space1, u32 as nom_u32},
    combinator::{map, value, verify},
    multi::{many0, separated_list0},
    sequence::separated_pair,
    IResult,
};
use std::{cmp::Ordering, cmp::Ordering::*, collections::HashMap};

use crate::ParseError;

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let mut bids = parse(data)?;
    bids.sort();

    Ok(bids
        .iter()
        .enumerate()
        .map(|(rank, bid)| bid.amount * (rank as u32 + 1))
        .sum::<u32>()
        .to_string())
}

pub fn part2(_data: &str) -> Result<String, Box<dyn std::error::Error>> {
    todo!()
}

#[derive(PartialEq, Eq, PartialOrd, Ord, Clone, Copy, Hash, Debug)]
enum Card {
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King,
    Ace,
}
use Card::*;

#[derive(Eq, PartialEq, Debug)]
struct Hand {
    cards: Vec<Card>,
}

impl Hand {
    fn new(c1: Card, c2: Card, c3: Card, c4: Card, c5: Card) -> Self {
        Self {
            cards: vec![c1, c2, c3, c4, c5],
        }
    }

    fn hand_type(&self) -> HandType {
        let groups = self
            .cards
            .iter()
            .fold(HashMap::new(), |mut acc: HashMap<Card, u32>, card| {
                acc.entry(*card)
                    .and_modify(|count| *count += 1)
                    .or_insert(1);
                acc
            });

        let mut groups = groups.into_values().collect::<Vec<_>>();
        groups.sort();
        groups.reverse();

        if groups[0] == 5 {
            FiveOfAKind
        } else if groups[0] == 4 {
            FourOfAKind
        } else if groups[0] == 3 && groups[1] == 2 {
            FullHouse
        } else if groups[0] == 3 {
            ThreeOfAKind
        } else if groups[0] == 2 && groups[1] == 2 {
            TwoPair
        } else if groups[0] == 2 {
            OnePair
        } else {
            HighCard
        }
    }
}

impl Ord for Hand {
    fn cmp(&self, other: &Self) -> Ordering {
        match self.hand_type().cmp(&other.hand_type()) {
            Equal => self
                .cards
                .iter()
                .zip(other.cards.iter())
                .find_map(|(c1, c2)| match c1.cmp(&c2) {
                    Equal => None,
                    c => Some(c),
                })
                .unwrap_or(Equal),
            c => c,
        }
    }
}

impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(&other))
    }
}

#[derive(PartialEq, Eq, PartialOrd, Ord)]
enum HandType {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}
use HandType::*;

#[derive(Eq, PartialEq, Ord, PartialOrd, Debug)]
struct Bid {
    hand: Hand,
    amount: Amount,
}

type Amount = u32;

fn parse(s: &str) -> Result<Vec<Bid>, ParseError> {
    let (_rest, bids) = bids(s).map_err(|e| ParseError(e.to_string()))?;

    Ok(bids)
}

fn bids(s: &str) -> IResult<&str, Vec<Bid>> {
    separated_list0(newline, bid)(s)
}

fn bid(s: &str) -> IResult<&str, Bid> {
    map(separated_pair(hand, space1, amount), |(hand, amount)| Bid {
        hand,
        amount,
    })(s)
}

fn hand(s: &str) -> IResult<&str, Hand> {
    map(cards, |cards| {
        Hand::new(cards[0], cards[1], cards[2], cards[3], cards[4])
    })(s)
}

fn cards(s: &str) -> IResult<&str, Vec<Card>> {
    verify(many0(card), |cards: &Vec<Card>| cards.len() == 5)(s)
}

fn card(s: &str) -> IResult<&str, Card> {
    alt((
        value(Ace, tag("A")),
        value(King, tag("K")),
        value(Queen, tag("Q")),
        value(Jack, tag("J")),
        value(Ten, tag("T")),
        value(Nine, tag("9")),
        value(Eight, tag("8")),
        value(Seven, tag("7")),
        value(Six, tag("6")),
        value(Five, tag("5")),
        value(Four, tag("4")),
        value(Three, tag("3")),
        value(Two, tag("2")),
    ))(s)
}

fn amount(s: &str) -> IResult<&str, Amount> {
    nom_u32(s)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_cards() {
        assert_eq!(
            cards("32T3K").unwrap(),
            ("", vec![Three, Two, Ten, Three, King])
        );
    }

    #[test]
    fn parse_bid() {
        assert_eq!(
            bid("32T3K 765").unwrap(),
            (
                "",
                Bid {
                    hand: Hand {
                        cards: vec![Three, Two, Ten, Three, King]
                    },
                    amount: 765
                }
            )
        );
    }

    #[test]
    fn cmp_hand() {
        let five = Hand::new(Ace, Ace, Ace, Ace, Ace);
        let four = Hand::new(Ten, Ace, Ace, Ace, Ace);
        let full_house = Hand::new(Two, Two, Ace, Ace, Ace);
        let three = Hand::new(Ten, Nine, Ace, Ace, Ace);
        let two_pair = Hand::new(Ten, Nine, Ace, Nine, Ace);
        let one_pair = Hand::new(Ten, Three, Ace, Nine, Ace);
        let high_cards = Hand::new(Ten, Nine, Ace, King, Queen);

        assert!(five == five);
        assert!(five > four);
        assert!(five > full_house);
        assert!(five > three);
        assert!(five > two_pair);
        assert!(five > one_pair);
        assert!(five > high_cards);

        assert!(four < five);
        assert!(four == four);
        assert!(four > full_house);
        assert!(four > three);
        assert!(four > two_pair);
        assert!(four > one_pair);
        assert!(four > high_cards);

        assert!(full_house < five);
        assert!(full_house < four);
        assert!(full_house == full_house);
        assert!(full_house > three);
        assert!(full_house > two_pair);
        assert!(full_house > one_pair);
        assert!(full_house > high_cards);

        assert!(three < five);
        assert!(three < four);
        assert!(three < full_house);
        assert!(three == three);
        assert!(three > two_pair);
        assert!(three > one_pair);
        assert!(three > high_cards);

        assert!(two_pair < five);
        assert!(two_pair < four);
        assert!(two_pair < full_house);
        assert!(two_pair < three);
        assert!(two_pair == two_pair);
        assert!(two_pair > one_pair);
        assert!(two_pair > high_cards);

        assert!(one_pair < five);
        assert!(one_pair < four);
        assert!(one_pair < full_house);
        assert!(one_pair < three);
        assert!(one_pair < two_pair);
        assert!(one_pair == one_pair);
        assert!(one_pair > high_cards);

        assert!(high_cards < five);
        assert!(high_cards < four);
        assert!(high_cards < full_house);
        assert!(high_cards < three);
        assert!(high_cards < two_pair);
        assert!(high_cards < one_pair);
        assert!(high_cards == high_cards);

        let mut cards = vec![
            &full_house,
            &three,
            &two_pair,
            &four,
            &one_pair,
            &high_cards,
            &five,
        ];
        cards.sort();
        assert_eq!(
            cards,
            vec![
                &high_cards,
                &one_pair,
                &two_pair,
                &three,
                &full_house,
                &four,
                &five
            ]
        )
    }

    #[test]
    fn cmp_hand_tie() {
        let card1 = Hand::new(King, King, Six, Seven, Seven);
        let card2 = Hand::new(King, Ten, Jack, Jack, Ten);
        assert!(card1 > card2);

        let card1 = Hand::new(Ten, Five, Five, Jack, Five);
        let card2 = Hand::new(Queen, Queen, Queen, Jack, Ace);
        assert!(card2 > card1);
    }
}
