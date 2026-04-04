use crate::BrewResult;
use crate::delegate;
use crate::homebrew;
use crate::matcher::Matcher;
use rust_fuzzy_search::fuzzy_search_threshold;
use std::process::ExitCode;

pub fn run(args: &[String]) -> BrewResult<ExitCode> {
    if args.len() != 2 || args[1].starts_with('-') {
        return delegate::run(args);
    }

    let api_cache = homebrew::cache_api_path()?;
    let formula_names = match homebrew::read_lines(&api_cache.join("formula_names.txt")) {
        Ok(names) if !names.is_empty() => names,
        _ => return delegate::run(args),
    };
    let cask_names = match homebrew::read_lines(&api_cache.join("cask_names.txt")) {
        Ok(names) => names,
        Err(_) => return delegate::run(args),
    };

    let matcher = Matcher::try_from(args[1].as_str())?;
    let matched_formulae = matched_names(&formula_names, &matcher);
    let matched_casks = matched_names(&cask_names, &matcher);

    if matched_formulae.is_empty() && matched_casks.is_empty() {
        eprintln!("No formulae or casks found for {:?}.", args[1]);
        return Ok(ExitCode::FAILURE);
    }

    homebrew::print_sections(&matched_formulae, &matched_casks);
    Ok(ExitCode::SUCCESS)
}

fn matched_names(names: &[String], matcher: &Matcher) -> Vec<String> {
    let matched_names = names
        .iter()
        .filter(|name| matcher.matches(name))
        .cloned()
        .collect::<Vec<_>>();
    if !matched_names.is_empty() {
        return matched_names;
    }

    let Matcher::String(query) = matcher else {
        return matched_names;
    };
    if query.len() < 3 {
        return matched_names;
    }

    let candidates = names.iter().map(String::as_str).collect::<Vec<_>>();
    let mut similar = fuzzy_search_threshold(query, &candidates, 0.5);
    similar.sort_by(|(_, left), (_, right)| right.total_cmp(left));
    similar
        .into_iter()
        .map(|(name, _)| name.to_string())
        .collect()
}

#[cfg(test)]
mod tests {
    use super::matched_names;
    use crate::matcher::Matcher;

    #[test]
    fn returns_plain_text_matches_before_fuzzy_results() {
        let names = vec!["testball".to_string(), "another".to_string()];
        let matcher = Matcher::try_from("testball").unwrap();

        assert_eq!(
            matched_names(&names, &matcher),
            vec!["testball".to_string()]
        );
    }

    #[test]
    fn returns_fuzzy_matches_for_long_plain_text_queries() {
        let names = vec!["testball".to_string(), "other".to_string()];
        let matcher = Matcher::try_from("testbal").unwrap();

        assert_eq!(
            matched_names(&names, &matcher),
            vec!["testball".to_string()]
        );
    }

    #[test]
    fn does_not_use_fuzzy_matching_for_short_queries() {
        let names = vec!["foo-bar".to_string()];
        let matcher = Matcher::try_from("fb").unwrap();

        assert!(matched_names(&names, &matcher).is_empty());
    }

    #[test]
    fn does_not_use_fuzzy_matching_for_regex_queries() {
        let names = vec!["testball".to_string()];
        let matcher = Matcher::try_from("/foo/").unwrap();

        assert!(matched_names(&names, &matcher).is_empty());
    }
}
