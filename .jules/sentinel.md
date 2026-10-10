## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.

## 2026-10-10 - Command Injection in bundle go extension
**Vulnerability:** Shell command injection risk via backticks in go extension with string interpolation of file paths.
**Learning:** String interpolation in backticks allows execution of arbitrary commands if the path contains malicious characters.
**Prevention:** Use array syntax with Utils.popen_read (or safe_system) to pass arguments securely, bypassing the shell.
