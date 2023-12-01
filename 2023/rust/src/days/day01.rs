pub fn part1(data: String) -> String {
    data.trim()
        .lines()
        .map(calibration)
        .sum::<u32>()
        .to_string()
}

pub fn part2(data: String) -> String {
    data.trim()
        .lines()
        .map(calibration2)
        .sum::<u32>()
        .to_string()
}

fn calibration(line: &str) -> u32 {
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

    n1 * 10 + n2
}

fn calibration2(line: &str) -> u32 {
    let n1 = line
        .char_indices()
        .find_map(|(i, _c)| digit_or_number(&line[i..], |s, start| s.starts_with(start)))
        .unwrap();

    let n2 = line
        .char_indices()
        .rev()
        .find_map(|(i, _c)| digit_or_number(&line[..=i], |s, start| s.ends_with(start)))
        .unwrap();
    n1 * 10 + n2
}

fn digit_or_number(s: &str, f: impl Fn(&str, &str) -> bool) -> Option<u32> {
    match s {
        s if f(s, "zero") || f(s, "0") => Some(0),
        s if f(s, "one") || f(s, "1") => Some(1),
        s if f(s, "two") || f(s, "2") => Some(2),
        s if f(s, "three") || f(s, "3") => Some(3),
        s if f(s, "four") || f(s, "4") => Some(4),
        s if f(s, "five") || f(s, "5") => Some(5),
        s if f(s, "six") || f(s, "6") => Some(6),
        s if f(s, "seven") || f(s, "7") => Some(7),
        s if f(s, "eight") || f(s, "8") => Some(8),
        s if f(s, "nine") || f(s, "9") => Some(9),
        &_ => None,
    }
}
