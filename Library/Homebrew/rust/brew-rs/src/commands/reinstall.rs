use crate::BrewResult;
use crate::delegate;
use std::process::ExitCode;

pub fn run(args: &[String]) -> BrewResult<ExitCode> {
    delegate::run_with_warning(args, "reinstall")
}
