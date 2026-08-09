## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.

## 2024-08-09 - Command Injection in Backticks Shell Evaluation
**Vulnerability:** Executing system commands using backticks with string interpolation (e.g. `` `"#{cmd}" --args 2>/dev/null` ``) passes the string to `/bin/sh`. If the command path or arguments contain shell metacharacters, it causes command injection.
**Learning:** Even if a command path is resolved via `which`, passing it through backticks is unsafe. `Utils.popen_read` and `Utils.safe_popen_read` must be used with array arguments instead.
**Prevention:** Replace backticks shell execution with `Utils.popen_read("cmd", "--arg", err: :close)` to bypass the shell. Ensure corresponding RSpec tests mock `Utils` rather than `described_class` receiving backticks.
