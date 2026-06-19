## 2024-04-24 - Command Injection in `safe_system` with string interpolation
**Vulnerability:** Calling `safe_system` with a single string containing interpolated variables (e.g., `safe_system "stackprof --d3-flamegraph #{prof_input_filename} > #{prof_filename}"`) allows shell command injection.
**Learning:** `safe_system "cmd #{var}"` passes the entire string to `/bin/sh` to be executed. If `var` is attacker-controlled, they can run arbitrary commands. It also fails to bypass `/bin/sh` with `execve`.
**Prevention:** Always use the array syntax for `safe_system` (e.g., `safe_system "cmd", "arg", out: file`) which bypasses the shell completely and prevents command injection.
## 2026-06-19 - Command Injection in Backticks via Interpolated Variable
**Vulnerability:** Command injection when using string interpolation inside backticks (e.g., `cmd "#{variable}"`) if the variable is attacker-controlled (like a filename from a directory listing).
**Learning:** Backticks execute the resulting string in the shell. Bypassing it by wrapping a variable in quotes is insufficient against backticks or \`$()\` executed by the shell.
**Prevention:** Use `Utils.popen_read` or similar functions with an array of arguments to bypass the shell.
