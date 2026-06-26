## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-05-27 - Replace unsanitized backticks with Utils.popen_read
**Vulnerability:** Use of string interpolation in backticks (e.g. `` `#{kubectl} krew list` ``) can lead to command injection if the variable is controlled by an attacker or unexpectedly contains shell metacharacters.
**Learning:** Homebrew's `Utils.popen_read` and `Utils.safe_popen_read` can safely execute commands and bypass the shell completely if arguments are passed as an array. Stderr redirection (`2>/dev/null`) can be achieved via the `err: :close` option.
**Prevention:** Avoid backticks with interpolated strings. Use `Utils.popen_read(cmd, arg, err: :close)` or `Utils.safe_popen_read` for all shell executions. Remember to update the respective RSpec mocks to allow `Utils` to receive `:popen_read` instead of `described_class` receiving `:```.
