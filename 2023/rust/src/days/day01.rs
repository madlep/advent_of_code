use thiserror::Error;

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    Ok(data
        .trim()
        .lines()
        .map(calibration)
        .sum::<Result<u32, E>>()?
        .to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    Ok(data
        .trim()
        .lines()
        .map(calibration2)
        .sum::<Result<u32, E>>()?
        .to_string())
}

#[derive(Error, Debug, PartialEq)]
enum E {
    #[error("couldn't find number in `{0}`")]
    MissingError(String),
}

fn calibration(line: &str) -> Result<u32, E> {
    let n1 = line
        .chars()
        .find(|c| c.is_ascii_digit())
        .ok_or(E::MissingError(line.to_string()))?
        .to_digit(10)
        .expect("should not fail to parse into digit, as we just checked it was a digit");

    let n2 = line
        .chars()
        .rfind(|c| c.is_ascii_digit())
        .ok_or(E::MissingError(line.to_string()))?
        .to_digit(10)
        .expect("should not fail to parse into digit, as we just checked it was a digit");

    Ok(n1 * 10 + n2)
}

fn calibration2(line: &str) -> Result<u32, E> {
    let n1 = line
        .char_indices()
        .find_map(|(i, _c)| digit_or_number(&line[i..], |s, start| s.starts_with(start)))
        .ok_or_else(|| E::MissingError(line.to_string()))?;

    let n2 = line
        .char_indices()
        .rev()
        .find_map(|(i, _c)| digit_or_number(&line[..=i], |s, start| s.ends_with(start)))
        .ok_or_else(|| E::MissingError(line.to_string()))?;

    Ok(n1 * 10 + n2)
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn calibration_parses_line() {
        assert_eq!(calibration("1abc2"), Ok(12));
        assert_eq!(calibration("pqr3stu8vwx"), Ok(38));
        assert_eq!(calibration("a1b2c3d4e5f"), Ok(15));
        assert_eq!(calibration("treb7uchet"), Ok(77));
    }

    #[test]
    fn calibration_fails_when_no_digits() {
        assert_eq!(calibration("abc"), Err(E::MissingError("abc".to_string())))
    }

    #[test]
    fn calibration2_parses_line() {
        assert_eq!(calibration2("two1nine"), Ok(29));
        assert_eq!(calibration2("eightwothree"), Ok(83));
        assert_eq!(calibration2("abcone2threexyz"), Ok(13));
        assert_eq!(calibration2("xtwone3four"), Ok(24));
        assert_eq!(calibration2("4nineeightseven2"), Ok(42));
        assert_eq!(calibration2("zoneight234"), Ok(14));
        assert_eq!(calibration2("7pqrstsixteen"), Ok(76));
    }

    #[test]
    fn calibration2_fails_when_no_digits() {
        assert_eq!(calibration2("abc"), Err(E::MissingError("abc".to_string())))
    }
}
