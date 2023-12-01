pub fn part1(data: String) -> String {
    data.trim()
        .split("\n")
        .map(first_last_digit)
        .map(|(n1, n2)| n1 * 10 + n2)
        .sum::<u32>()
        .to_string()
}

pub fn part2(data: String) -> String {
    data.trim()
        .split("\n")
        .map(first_last_digit_words)
        .map(|(n1, n2)| n1 * 10 + n2)
        .sum::<u32>()
        .to_string()
}

fn first_last_digit(line: &str) -> (u32, u32) {
    let n1 = line
        .chars()
        .find(|c| c.is_digit(10))
        .unwrap()
        .to_digit(10)
        .unwrap();

    let n2 = line
        .chars()
        .rfind(|c| c.is_digit(10))
        .unwrap()
        .to_digit(10)
        .unwrap();

    (n1, n2)
}

fn first_last_digit_words(line: &str) -> (u32, u32) {
    let mut n1 = 0;
    for i in 0..line.len() {
        let n = parse_digit_or_word_start(&line[i..]);
        if n.is_some() {
            n1 = n.unwrap();
            break;
        }
    }

    let mut n2 = 0;
    for i in 0..line.len() {
        let n = parse_digit_or_word_end(&line[0..line.len() - i]);
        if n.is_some() {
            n2 = n.unwrap();
            break;
        }
    }
    (n1, n2)
}

fn parse_digit_or_word_start(s: &str) -> Option<u32> {
    match s {
        s if s.starts_with("zero") || s.starts_with("0") => Some(0),
        s if s.starts_with("one") || s.starts_with("1") => Some(1),
        s if s.starts_with("two") || s.starts_with("2") => Some(2),
        s if s.starts_with("three") || s.starts_with("3") => Some(3),
        s if s.starts_with("four") || s.starts_with("4") => Some(4),
        s if s.starts_with("five") || s.starts_with("5") => Some(5),
        s if s.starts_with("six") || s.starts_with("6") => Some(6),
        s if s.starts_with("seven") || s.starts_with("7") => Some(7),
        s if s.starts_with("eight") || s.starts_with("8") => Some(8),
        s if s.starts_with("nine") || s.starts_with("9") => Some(9),
        &_ => None,
    }
}

fn parse_digit_or_word_end(s: &str) -> Option<u32> {
    match s {
        s if s.ends_with("zero") || s.ends_with("0") => Some(0),
        s if s.ends_with("one") || s.ends_with("1") => Some(1),
        s if s.ends_with("two") || s.ends_with("2") => Some(2),
        s if s.ends_with("three") || s.ends_with("3") => Some(3),
        s if s.ends_with("four") || s.ends_with("4") => Some(4),
        s if s.ends_with("five") || s.ends_with("5") => Some(5),
        s if s.ends_with("six") || s.ends_with("6") => Some(6),
        s if s.ends_with("seven") || s.ends_with("7") => Some(7),
        s if s.ends_with("eight") || s.ends_with("8") => Some(8),
        s if s.ends_with("nine") || s.ends_with("9") => Some(9),
        &_ => None,
    }
}
