## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2024-05-24 - [Command Injection with Backticks]
**Vulnerability:** Shell interpolation with backticks (`` `cmd #{var}` ``) fails to sanitize arguments, leading to potential command injection.
**Learning:** Homebrew provides `Utils.popen_read` and `Utils.safe_popen_read` to execute commands securely by passing arguments as an array instead of a single string.
**Prevention:** Use `Utils.popen_read(cmd, arg, err: "/dev/null")` to safely execute shell commands and avoid backticks. Update tests using `allow(Utils).to receive(:popen_read)` instead of mocking backticks.
