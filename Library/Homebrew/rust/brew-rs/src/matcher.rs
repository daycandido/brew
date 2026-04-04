use crate::BrewResult;
use regex::Regex;

pub(crate) enum Matcher {
    Regex(Regex),
    String(String),
}

impl TryFrom<&str> for Matcher {
    type Error = anyhow::Error;

    fn try_from(query: &str) -> BrewResult<Self> {
        if query.len() > 2 && query.starts_with('/') && query.ends_with('/') {
            Regex::new(&query[1..query.len() - 1])
                .map(Self::Regex)
                .map_err(|error| anyhow::anyhow!("{query} is not a valid regex: {error}"))
        } else {
            Ok(Self::String(simplify_string(query)))
        }
    }
}

impl Matcher {
    pub(crate) fn matches(&self, value: &str) -> bool {
        match self {
            Self::Regex(regex) => regex.is_match(value),
            Self::String(string) => simplify_string(value).contains(string),
        }
    }
}

fn simplify_string(value: &str) -> String {
    value
        .chars()
        .filter_map(|character| {
            let lowered = character.to_ascii_lowercase();
            if lowered.is_ascii_alphanumeric() || lowered == '@' || lowered == '+' {
                Some(lowered)
            } else {
                None
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::{Matcher, simplify_string};

    #[test]
    fn parses_regex_queries() {
        let matcher = Matcher::try_from("/test.*/").unwrap();
        assert!(matches!(matcher, Matcher::Regex(_)));
    }

    #[test]
    fn rejects_invalid_regex_queries() {
        let error = match Matcher::try_from("/[/") {
            Ok(_) => panic!("expected invalid regex query to fail"),
            Err(error) => error,
        };

        assert!(error.to_string().contains("is not a valid regex"));
    }

    #[test]
    fn matches_simplified_plain_text_queries() {
        let matcher = Matcher::try_from("foo-bar").unwrap();
        assert!(matcher.matches("Foo Bar"));
    }

    #[test]
    fn simplify_string_keeps_only_matching_characters() {
        assert_eq!(simplify_string("Foo+Bar@1!"), "foo+bar@1");
    }
}
