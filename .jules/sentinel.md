## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2026-06-10 - Command Injection in backticks execution with string interpolation
**Vulnerability:** Calling backticks `${go} version -m "${binary}" 2>/dev/null` where `binary` is a filename interpolated directly into the command string allows shell command injection.
**Learning:** Backticks execute using `/bin/sh`. If a filename is attacker-controlled, they can run arbitrary commands. Shell escaping is error-prone.
**Prevention:** Always use `Utils.popen_read("cmd", "arg", var)` or similar array-based execution to bypass the shell completely and prevent command injection.
