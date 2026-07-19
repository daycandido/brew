## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2026-04-29 - Command Injection in Shell Command Execution via Backticks
**Vulnerability:** Found multiple usages of shell backticks with string interpolation (e.g., `go version -m "#{binary}"`) that could lead to command injection if `binary` contained shell metacharacters.
**Learning:** Backticks execute strings in a subshell, inherently exposing the command to shell injection vulnerabilities when user or external input is part of the string.
**Prevention:** Always use `Utils.popen_read` (or `Utils.safe_popen_read` or `system`) with array arguments (bypassing the shell and calling `execve` directly) instead of string interpolation when variables are involved.
