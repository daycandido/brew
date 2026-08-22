## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.

## 2024-05-24 - Command Injection via Backticks
**Vulnerability:** Using backticks (`` `...` ``) with string interpolation (e.g., `` `#{cmd} arg` ``) is vulnerable to command injection if `cmd` or `arg` comes from an untrusted source, because the entire string is evaluated by the shell.
**Learning:** Shell command execution via backticks in Ruby invokes a subshell, meaning any unescaped string interpolation could lead to arbitrary command execution.
**Prevention:** Use `Utils.popen_read` with explicit arguments (e.g., `Utils.popen_read(cmd, "arg")`) instead of backticks with string interpolation, as it bypasses the shell.
